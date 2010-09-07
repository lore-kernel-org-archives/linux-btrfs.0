From: Daniel Kozlowski <dan.kozlowski@gmail.com>
Subject: Re: mkfs or wait?
Date: Tue, 7 Sep 2010 09:48:29 -0400
Message-ID: <AANLkTinCkFctLELtMNRR9=1PyvBQvKmBt-n-pXg1czMA@mail.gmail.com>
References: <i64k40$ur1$1@dough.gmane.org>
	<i65flv$6tn$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i65flv$6tn$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had a similar issue There was a Segmenation fault showing up in
dmesg that wasen't showing up in /var/log/messages. In my case
upgrading to the git tree let me read and write to the filesystem.

On Tue, Sep 7, 2010 at 9:45 AM, Lubos Kolouch <lubos.kolouch@gmail.com>=
 wrote:
> Lubos Kolouch, Tue, 07 Sep 2010 05:55:12 +0000:
>
>> Hello,
>>
>> I have on one computer damaged btrfs filesystem... it was a strange
>> crash, it showed about 30% free space, however then the volume crash=
ed
>> with 'no space left' messages and after reboot it is unusable.
>>
>> I can mount it, I can df it but when I try for example ls, ls gets s=
tuck
>> (does not display anything) and I get - in the syslog
>> verify_parent_transid: 22336 callbacks suppressed parent transid ver=
ify
>> failed on 1066975232 wanted 125077 found 125075 parent transid verif=
y
>> failed on 974635008 wanted 125077 found 125075 parent transid verify
>> failed on 1066975232 wanted 125077 found 125075 parent transid verif=
y
>> failed on 974635008 wanted 125077 found 125075 parent transid verify
>> failed on 1066975232 wanted 125077 found 125075 parent transid verif=
y
>> failed on 974635008 wanted 125077 found 125075 parent transid verify
>> failed on 1066975232 wanted 125077 found 125075 parent transid verif=
y
>> failed on 974635008 wanted 125077 found 125075 parent transid verify
>> failed on 1066975232 wanted 125077 found 125075 parent transid verif=
y
>> failed on 974635008 wanted 125077 found 125075
>>
>> - top shows
>> ls
>> [btrfs-endio-met]
>> [btrfs-cache-293]
>>
>> - btrfs segfaults
>>
>> It is like this over a day. Should I just mkfs it or is there anythi=
ng
>> sensible I could try?
>>
>> kernel 2.6.35-gentoo-r5, latest git btrfs-progs
>>
>> Thank you for your advice.
>>
>> Lubos
>
> Funny thing - under 2.6.34-r1 it works, ie. I can mount it and view f=
iles
> (even though the errors in log are still there).
>
> Regression in 2.6.35?
>
> Lubos
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
S.D.G.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
