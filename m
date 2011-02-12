From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: 2.6.37: bash is looping unkillably in btrfs
Date: Sat, 12 Feb 2011 16:29:41 -0500
Message-ID: <AANLkTi=oBvsjxichNbAFGND05XG8GVMds5PwRLL5Amco@mail.gmail.com>
References: <AANLkTinSuRoiaTcPOV7_X=Zs+4-ad-Gx-oKWuhyHpjsO@mail.gmail.com> <20110212212249.GB19533@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110212212249.GB19533@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 12, 2011 at 4:22 PM, Josef Bacik <josef@redhat.com> wrote:
> On Sat, Feb 12, 2011 at 02:53:31PM -0500, Andrew Lutomirski wrote:
>> I have two processes that are unkillable and taking about 50% of a C=
PU
>> each. =A0There is no actual I/O happening (disk light is off and the
>> disk even spun down after awhile). =A0This may or may not be related=
 to
>> unmounting a filesystem. =A0(I'm not sure -- I have two btrfs
>> failesystems and I unmounted one before I noticed the problem).
>>
>> [...]
> It will finish eventually, fixes for this went into -rc4. =A0Thanks,

Any plans for -stable?  (Upgrading to a -rc kernel to make a
filesystem work seems scary.)

Is it same to assume that my data is all ok?  (I have a backup and I'd
like to know whether I should restore from it right now...)

--Andy

>
> Josef
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
