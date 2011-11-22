From: =?UTF-8?Q?Ren=C3=A9_Vangsgaard?= <rene.vangsgaard@gmail.com>
Subject: Re: mount errors
Date: Tue, 22 Nov 2011 14:01:35 +0100
Message-ID: <CAPWZyXbfQFFxY1UMqpBYn3OnLR=tG9joEc5Mg91Gj348=8mhwg@mail.gmail.com>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
	<ad43919226351cd8f695a0dfc44adc81@www.jots.org>
	<CAPWZyXZPVXVxGo3XwTc0j6o3exk7+HnNtsaAoa0JsyrAML_CVQ@mail.gmail.com>
	<CAE5mzvhbfo=LsAv8OZNjX9o=jaP0-cE4f8cTYn4EGWhxtgtsEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ken D'Ambrosio" <ken@jots.org>, linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvhbfo=LsAv8OZNjX9o=jaP0-cE4f8cTYn4EGWhxtgtsEQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I have decided to update progs from git. The instructions on the wiki
do not really help me out (for example I cannot checkout branch
"for-chris"). Can anyone tell me what branch (probably integration) to
use on kernel 3.0.0? Or just point me to a site with working
instructions.

Thank you, Ren=C3=A9

On 22 November 2011 05:55, cwillu <cwillu@cwillu.com> wrote:
> On Mon, Nov 21, 2011 at 5:29 PM, Ren=C3=A9 Vangsgaard
> <rene.vangsgaard@gmail.com> wrote:
>> Thank you for answering.
>>
>> 2) I get this error when mounting:
>> couldn't open because of unsupported option features (8).
>> fsck.btrfs: disk-io.c:679: open_ctree_fd: Assertion `!(1)' failed.
>
> You're running an out-of-date version of btrfs-progs, which doesn't
> understand lzo.
>
>> My current mount options are
>> defaults,compress=3Dlzo,subvol=3D@home
>> I have tried removing the compress=3Dlzo with no difference.
>
> Removing compress=3Dlzo doesn't remove compression from existing bloc=
ks.
>
> Just disable fsck from running on boot (or update your progs from git=
).
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
