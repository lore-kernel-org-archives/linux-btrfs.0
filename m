From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: COW a file from snapshot
Date: Thu, 22 Dec 2011 09:12:13 +0100
Message-ID: <CABVOS0-7-UCetP03VS3rMPTnFYJ0+9r-PEypcY1cMd_oovr33g@mail.gmail.com>
References: <20111220150717.GA24891@hendrix.borisch.local> <CALJXSJpTv2jJN6=J4tQygjAufuMt_FY=2Zg1=Xcwyb9qOUejJw@mail.gmail.com>
 <CALJXSJp4jzfjyo3msvt=ZHvtidBkNZ5CSsfr9rjReLzWet_Pqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave <dave@thekilempire.com>, linux-btrfs@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJp4jzfjyo3msvt=ZHvtidBkNZ5CSsfr9rjReLzWet_Pqg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 21, 2011 at 22:31, J=C3=A9r=C3=B4me Poulin <jeromepoulin@gm=
ail.com> wrote:
> Did you get any success with the patch?
> Reading the conversation, people seemed to agree that this feature
> should be included, anyway, snapshot already share data, why not be
> able to copy them?

I'm using btrfs for about two years and this is the key feature I'm
missing all the time. Why is it not part of mainline btrfs already?

>
> Other link with title for mailing list reference.
> [PATCH 2/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/9865
>
> On Tue, Dec 20, 2011 at 12:53 PM, J=C3=A9r=C3=B4me Poulin <jeromepoul=
in@gmail.com> wrote:
>>
>> You would need to apply this patch to your kernel:
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09096.htm=
l
>>
>> Is there any chance this patch gets in linux-next ?
>> I use this feature all the time and it never broke on me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
