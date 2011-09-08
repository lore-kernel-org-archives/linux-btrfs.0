From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: mount a multi-device filesystem using a loopback device
Date: Thu, 8 Sep 2011 00:32:53 -0500
Message-ID: <CAGAVQTGsH4SLvvwAZaqEpuk-9CjK-0H2QEXrF76qfFcbqr9pOA@mail.gmail.com>
References: <4E66F090.4030507@oracle.com> <CAE5mzvjjHh2SZ42o7spb0LQZzsnmf4Dn1hN-JQ-HcFSeZa2dXA@mail.gmail.com>
 <4E6712CC.3040404@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: jeff.liu@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E6712CC.3040404@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 7, 2011 at 1:44 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 09/07/2011 12:37 PM, cwillu wrote:
>>>
>>> 1. =C2=A0Create and format two images, the 1st in 400Mbytes, and 2n=
d in
>>> 286Mbytes.
>>> root@pibroch:/btrfs-progs# ls -lh /usr/src/linux-3.0/img*
>>> -rw-r--r-- 1 jeff jeff 400M 2011-09-07 12:00 /usr/src/linux-3.0/img=
0
>>> -rw-r--r-- 1 jeff jeff 286M 2011-09-07 12:00 /usr/src/linux-3.0/img=
1
>>
>> Very small btrfs filesystem require special handling, mixed block
>> groups in particular, which I believe also requires an updated mkfs
>> from the integration repo.
>
> Thanks for your response, however, even if I enlarged the image size =
to 2G,
> still got no luck.
> Per Zefan's comments, run 'btrfs device scan' fixed this issue.

you should be able to achieve this via `device=3D` mount option(s?) as =
well:

https://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options

=2E.. for completeness :-) ... and posterity or whatever.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
