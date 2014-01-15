Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaAOAko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 19:40:44 -0500
From: "Timothy Pepper" <timothy.c.pepper@linux.intel.com>
Date: Tue, 14 Jan 2014 16:40:28 -0800
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs-progs: Add optional 'uuid' parameter to
 mkfs.btrfs
Message-ID: <20140115004028.GB7850@tcpepper-desk.jf.intel.com>
References: <20140108215058.GA31124@tcpepper-desk.jf.intel.com>
 <20140114160629.GY6498@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140114160629.GY6498@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 14 Jan at 17:06:29 +0100 dsterba@suse.cz said:
> On Wed, Jan 08, 2014 at 01:50:58PM -0800, Timothy Pepper wrote:
> > The patch below is a simple quick attempt at allowing the filesystem
> > UUID to be specified by the user at mkfs time.
> 
> There was a similar patch some time ago, that also added it to convert:
> http://www.spinics.net/lists/linux-btrfs/msg21193.html
> 
> and my comments apply to your patch as well:
> http://www.spinics.net/lists/linux-btrfs/msg22889.html
> 
> "Can you please enhance it with a check that the UUID is not duplicate
> among other filesystems? It should be available through libblkid:
> 
> 	blkid_probe_lookup_value(probe, "UUID", &uuid, NULL);
> 
> This is a sort of paranoia check with the generated UUID, but I think
> that an accidentally repeated command or copy&paste with an existing
> uuid can happen."

This makes sense, but feels like a separate and distinct need.  I've
simply followed the existing implementation for user specified labels.
Both arguably should have additional logic for interacting with the user
or making explicit whether a duplicate UUID/LABEL is or is not allowable
to the user.  In my oddball use case I happen to be ok with a duplicate
UUID's and explicitly want them ;)

> 
> > @@ -335,12 +336,25 @@ static char *parse_label(char *input)
> >  	return strdup(input);
> >  }
> >  
> > +static char *parse_uuid(char *input)
> 
> please use libuuid API instead

As in uuid_parse(), which I use later?

> > +{
> > +	int len = strlen(input);
> > +#define	BTRFS_UUID_STRING_SIZE	(2*BTRFS_UUID_SIZE + 5)
> > +	if (len >= BTRFS_UUID_STRING_SIZE) {
> > +		fprintf(stderr, "UUID %s is too long (max %d)\n", input,
> > +			BTRFS_UUID_STRING_SIZE - 1);
> > +		exit(1);
> > +	}
> > +	return strdup(input);
> > +}
> > +
> > @@ -1288,6 +1303,9 @@ int main(int ac, char **av)
> >  			case 'L':
> >  				label = parse_label(optarg);
> >  				break;
> > +			case 'U':
> > +				uuid = parse_uuid(optarg);
> 
> Error handling needed.

The uuid is initialized to NULL, same as label.  The two
parse_{uuid,name}() functions return a strdup of the user input or
exit(1).  If strdup returned NULL, it's the same is if the user gave no
input and the code didn't hit the 'L' and/or 'U' cases.

The patch may make more sense in the context of the full file where you
see it mirroring the user specified label case in the lines just prior
to each addition hunk in mkfs.c.

This makes for a simpler, more natural addition in utils.c where I've
done the following hunk:

diff --git a/utils.c b/utils.c
index f499023..4b85eeb 100644
--- a/utils.c
+++ b/utils.c
@@ -71,7 +71,7 @@ static u64 reference_root_table[] = {
 	[6] =	BTRFS_CSUM_TREE_OBJECTID,
 };
 
-int make_btrfs(int fd, const char *device, const char *label,
+int make_btrfs(int fd, const char *device, const char *label, const char *uuid,
 	       u64 blocks[7], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features)
 {
@@ -103,7 +103,10 @@ int make_btrfs(int fd, const char *device, const char *label,
 	memset(&super, 0, sizeof(super));
 
 	num_bytes = (num_bytes / sectorsize) * sectorsize;
-	uuid_generate(super.fsid);
+	if (uuid)
+		uuid_parse(uuid, super.fsid);
+	else
+		uuid_generate(super.fsid);
 	uuid_generate(super.dev_item.uuid);
 	uuid_generate(chunk_tree_uuid);

I could remove the strdup in mkfs.c, move the uuid_parse() up into mkfs.c,
and do a memcpy into super down here.  The way I did it seem the easiest
to understand for overall code readability within each of mkfs.c and
utils.c, keeping a similar set of initializations in mkfs.c and the set
of uuid_*() calls next to each other in utils.c.

After that hunk in utils.c, and even without my change, the code
could/should check whether these three uuid's are unique and enable policy
choice there.

-- 
Tim Pepper <timothy.c.pepper@linux.intel.com>
Intel Open Source Technology Center
