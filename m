From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: Re: crash when mounting
Date: Mon, 4 Aug 2008 15:59:20 +0300
Message-ID: <3da3b5b40808040559h75d03539mbd408bd81a058844@mail.gmail.com>
References: <3da3b5b40808021612q1ec112c2jae0769b0abdcceb5@mail.gmail.com>
	 <1217854042.29139.41.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217854042.29139.41.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Well, yeah sure. But I was kind of hoping my playing/testing is going
to help you guys fix it. So, does that traceback help you pin point
the problem ? If not, is there anything I can do, to help with that ?
I believe this crash should be re-producible .. haven't tested that
though

Regards

On Mon, Aug 4, 2008 at 3:47 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Sun, 2008-08-03 at 02:12 +0300, Ahmed Kamal wrote:
>> Hi guys,
>> I was playing on vmware with btrfs on complete disks /dev/sd{b,c,d,e}.
>> Next I decided to use partitions, so I created /dev/sd{b,c,d,e}1 and
>> used those, worked fine! Afterward, I mistakenly re-ran an old command
>> on the full disk ( mount -t btrfs -o subvol=. /dev/sdb /mnt/ ) notice
>> this is sdb not sdb1, and I got this spectacular kernel freeze. Let me
>> know if that's some bug.
>
> It would be nice if we didn't oops, there is clearly some hardening to
> do in the failure paths for corrupt filesystems.
>
> -chris
>
>
>
