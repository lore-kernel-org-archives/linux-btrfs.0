From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [PATCH] Subvolume listing feature for ioctl.
Date: Sat, 12 Dec 2009 09:31:25 +0900
Message-ID: <4B22E45D.7000106@jp.fujitsu.com>
References: <4B00ADE8.4090205@jp.fujitsu.com> <3d0408630911160015t79044d72u3489a42d57c6f844@mail.gmail.com> <4B011435.2080005@jp.fujitsu.com> <4B038897.3000605@jp.fujitsu.com> <4B038936.5020506@jp.fujitsu.com> <20091211205718.GP2191@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yanzheng@21cn.com, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091211205718.GP2191@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your report.

I'm going to reprocude this panic and fix it maybe next week.

Regards,
taruisi
(2009/12/12 5:57), Josef Bacik wrote:
> On Wed, Nov 18, 2009 at 02:42:14PM +0900, TARUISI Hiroaki wrote:
>> New feature to list up subvolume/snapshots under
>> specified tree of file is introduced to ioctl.
>>
>> Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |  283 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/ioctl.h |   29 +++++
>>  2 files changed, 312 insertions(+)
>>
> 
> I've been using this patch to work with my subvolume mounting patches, and it
> seems to have a problem where it will panic the box.  At first I thought it was
> something that I did, but on a freshly mkfs'ed fs I can reproduce the panic
> without doing any of the subvolume mounting weirdness.  If I do btrfsctl -l a
> couple of times it will panic.  This most recent time I did a btrfsctl -l on an
> empty fs, created a subvolume, did a list again, created another subvolume, and
> tried to list again and the box paniced.  I don't have time to look into this
> now, but I will look into it next week if you haven't had a chance to get to it
> before then.  Thanks,
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
taruisi

