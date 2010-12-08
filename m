From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: What to do about subvolumes?
Date: Tue, 7 Dec 2010 23:39:35 -0700
Message-ID: <FA094332-A4D7-4EF6-BB28-ECB3C36ECD01@dilger.ca>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <20101203222756.GF23339@dastard> <1291415351-sup-4820@think> <20101203224525.GC12491@pad.home.fieldses.org> <26801711-6DF9-4122-BCDF-033A1781C3E4@dilger.ca> <20101206164844.GA22447@pad.home.fieldses.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: "J. Bruce Fields" <bfields@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206164844.GA22447@pad.home.fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-12-06, at 09:48, J. Bruce Fields wrote:
On Fri, Dec 03, 2010 at 04:01:44PM -0700, Andreas Dilger wrote:
>> Any chance we can add a ->get_fsid(sb, inode) method to
>> export_operations (or something simiar), that allows the filesystem to
>> generate an FSID based on the volume and inode that is being exported?
> 
> No objection from here.
> 
> (Though I don't understand the inode argument--aren't "subvolumes"
> usually expected to have separate superblocks?)

I thought that if two directories from the same filesystem are both being exported at the same time that they would need to have different FSID values, hence the inode parameter to allow generating an FSID that is a function of both the filesystem (sb) and the directory being exported (inode)?

Cheers, Andreas





