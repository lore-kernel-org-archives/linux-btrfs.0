From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: What to do about subvolumes?
Date: Wed, 8 Dec 2010 21:41:33 -0700
Message-ID: <FBF72E13-C120-44FF-AFB0-1B4F9B06DFBE@dilger.ca>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <20101203222756.GF23339@dastard> <1291415351-sup-4820@think> <20101203224525.GC12491@pad.home.fieldses.org> <26801711-6DF9-4122-BCDF-033A1781C3E4@dilger.ca> <20101206164844.GA22447@pad.home.fieldses.org> <20101209100711.6e6541e1@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: "J. Bruce Fields" <bfields@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>,
	"K. V K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101209100711.6e6541e1@notabene.brown>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-12-08, at 16:07, Neil Brown wrote:
> On Mon, 6 Dec 2010 11:48:45 -0500 "J. Bruce Fields" <bfields@redhat.com>
> wrote:
> 
>> On Fri, Dec 03, 2010 at 04:01:44PM -0700, Andreas Dilger wrote:
>>> Any chance we can add a ->get_fsid(sb, inode) method to
>>> export_operations (or something simiar), that allows the
>>> filesystem to generate an FSID based on the volume and
>>> inode that is being exported?
>> 
>> No objection from here.
> 
> My standard objection here is that you cannot guarantee that the
> fsid is 100% guarantied to be unique across all filesystems in
> the system (including filesystems mounted from dm snapshots of
> filesystems that are currently mounted).  NFSd needs this uniqueness.

Sure, but you also cannot guarantee that the devno is constant across reboots, yet NFS continues to use this much-less-constant value...

> This is only really an objection if user-space cannot over-ride
> the fsid provided by the filesystem.

Agreed.  It definitely makes sense to allow this, for whatever strange circumstances might arise.  However, defaulting to using the filesystem UUID definitely makes the most sense, and looking at the nfs-utils mountd code, it seems that this is already standard behaviour for local block devices (excluding "btrfs" filesystems).

> I'd be very happy to see an interface to user-space whereby
> user-space can get a reasonably unique fsid for a given
> filesystem.

Hmm, maybe I'm missing something, but why does userspace need to be able to get this value?  I would think that nfsd gets it from the filesystem directly in the kernel, but if a "uuid=" option is present in the exports file that is preferentially used over the value from the filesystem.

That said, I think Aneesh's open_by_handle patchset also made the UUID visible in /proc/<pid>/mountinfo, after the filesystems stored it in
sb->s_uuid at mount time.  That _should_ make it visible for non-block mountpoints as well, assuming they fill in s_uuid.

> Whether this is an export_operations method or some field in the
> 'struct super' which gets copied out doesn't matter to me.

Since Aneesh has already developed patches, is there any objection to using those (last sent to linux-fsdevel on 2010-10-29):

[PATCH -V22 12/14] vfs: Export file system uuid via /proc/<pid>/mountinfo
[PATCH -V22 13/14] ext3: Copy fs UUID to superblock.
[PATCH -V22 14/14] ext4: Copy fs UUID to superblock

Cheers, Andreas





