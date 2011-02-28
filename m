From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Date: Mon, 28 Feb 2011 08:53:31 +0100
Message-ID: <AANLkTinKCUeHLmz3CFh_k3oxEW-p8ta0djGFK3q8vQ+0__11826.4710916721$1298879639$gmane$org@mail.gmail.com>
References: <4D6221B8.9040303@gmail.com>
	<20110221124635.GA5525@infradead.org>
	<AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
	<20110227224940.GL2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	cluster-devel@redhat.com,
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110227224940.GL2924@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011/2/27 Ted Ts'o <tytso@mit.edu>:
> On Mon, Feb 21, 2011 at 05:50:21PM +0100, Marco Stornelli wrote:
>> 2011/2/21 Christoph Hellwig <hch@infradead.org>:
>> > On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>> >> From: Marco Stornelli <marco.stornelli@gmail.com>
>> >>
>> >> All fs must check for the immutable flag in their fallocate callb=
ack.
>> >> It's possible to have a race condition in this scenario: an appli=
cation
>> >> open a file in read/write and it does something, meanwhile root s=
et the
>> >> immutable flag on the file, the application at that point can cal=
l
>> >> fallocate with success. Only Ocfs2 check for the immutable flag a=
t the
>> >> moment.
>> >
>> > Please add the check in fs/open.c:do_fallocate() so that it covers=
 all
>> > filesystems.
>> >
>> >
>>
>> The check should be done after the fs got the inode mutex lock.
>
> Why? =A0None of the other places which check the IMMUTABLE flag do so
> under the inode mutex lock. =A0Yes, it's true that we're not properly
> doing proper locking when updating i_flags from the ioctl (this is
> true for all file systems), but this has been true for quite some
> time, and using a mutex to protect bit set/clear/test operations woul=
d
> be like using a sledgehammer to kill a fly.
>
> A proper fix if we want to be completely correct about updates to
> i_flags would involve using test_bit, set_bit, and clear_bit, which i=
s
> guaranteed to be atomic. =A0This is how we update the
> ext4_inode_info->i_flags (which is different from inode->i_flags) (se=
e
> the definition and use of EXT4_INODE_BIT_FNS in fs/ext4/ext4.h).
>
> At some point, it would be good to fix how we set/get i_flags values,
> but that's independent of the change that's being discussed here.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

I was thinking to the possible race with setattr callback.

Marco
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
