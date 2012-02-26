From: Daniel Lee <longinus00@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 12:25:19 -0800
Message-ID: <4F4A952F.6010203@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org> <4F4A8A13.2070305@gmail.com> <jie2b6$nla$1@dough.gmane.org> <4F4A8D7A.5070605@gmail.com> <jie3b2$v5d$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jie3b2$v5d$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2012 12:05 PM, Brian J. Murrell wrote:
> On 12-02-26 02:52 PM, Daniel Lee wrote:
>> What's mysterious about that?
> What's mysterious about needing to grow the filesystem to over 20GB to
> unpack 10MB of (small, so yes, many) files?
>> When you shrink it btrfs is going to throw
>> away unused data to cram it all in the requested space and you had empty
>> space that was taken up by the metadata allocation.
> The shrinking is secondary mystery.  It's the need for more than 20GB of
> space for less than 3GB of files that's the major mystery.
Several people in this list have already answered this question but here
goes.

Btrfs isn't like other more common filesystems where metadata is fixed
at filesystem creation. Rather, metadata allocations happen just like
data allocations do. Btrfs also tries to allocate metadata in big chunks
so it doesn't get fragmented and lead to slowdowns when doing something
like running du on the root folder. The downside to all of this is that
it's not very friendly to "small" filesystems, in your case it allocated
some 1.8 GB of metadata of which only 500 MB was actually in use.

In the future you can create your filesystem with metadata=single to
free up more space for regular data or look into forcing the mixed block
groups mode which is normally only enabled for 1GB or smaller
filesystems. Mixed block group mode can't be switched off so you could
make a really tiny FS, several hunder MB or so, and then just grow it to
whatever size you want. The btrfs wiki seems to define small filesystems
as anything under 16GB so might be a good lower bound for actually using
btrfs in a day to day environment.


