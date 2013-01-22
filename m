Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab3AVOqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 09:46:40 -0500
Date: Tue, 22 Jan 2013 15:46:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        dsterba@suse.cz, Gene Czarcinski <gene@czarc.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/13] Add btrfs-show-super
Message-ID: <20130122144638.GE28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-6-git-send-email-gene@czarc.net>
 <20130121180421.GB7971@twin.jikos.cz>
 <50FD9D13.5060401@gmail.com>
 <50FDBF89.1050009@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FDBF89.1050009@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 21, 2013 at 11:22:01PM +0100, Stefan Behrens wrote:
> On 01/21/2013 20:54, Goffredo Baroncelli wrote:
> >On 01/21/2013 07:04 PM, David Sterba wrote:
> >>On Sun, Jan 20, 2013 at 04:04:10PM -0500, Gene Czarcinski wrote:
> >>>From: Goffredo Baroncelli<kreijack@inwind.it>
> >>>
> >>What I'm missing here is Stefan's S-o-B line, as he's the original
> >>author of the tool, adding it, JFYI.
> >
> >I am not sure if he want to Sign it. During the review he blamed about
> >some style issues. But for time constraints I was not able to update the
> >patches.
> >
> >So before adding Stefen's S-o-B we need an ack from him.
> 
> For the record, all the extra spaces are not from me.

Thanks, s-o-b is there and I've removed them and added

@@ -125,7 +125,7 @@ int main(int argc, char **argv)

 static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr)
 {
-       u8      super_block_data[BTRFS_SUPER_INFO_SIZE];
+       u8 super_block_data[BTRFS_SUPER_INFO_SIZE];
        struct btrfs_super_block *sb;
        u64 ret;

@@ -166,12 +166,12 @@ static int check_csum_sblock(void *sb, int csum_size)

 static void dump_superblock(struct btrfs_super_block *sb)
 {
-       int     i;
-       char    *s, buf[36+1];
-       u8      *p;
+       int i;
+       char *s, buf[36+1];
+       u8 *p;
---

also a whitespace change, that sticks to the common style in progs.

david
