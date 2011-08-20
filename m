From: Liam <liam.bulkley@gmail.com>
Subject: Re: kernel oops -> no mount (different problem than others)
Date: Sat, 20 Aug 2011 01:53:39 -0400
Message-ID: <CAO2p3yFyDUAA9PjaGRdTfDia7G_RsxGf8F_BECpaDP1ibk3UTQ@mail.gmail.com>
References: <CAO2p3yF57i2MeszoUHnFy3W-S_Dm-bMHJzY2GYULgxnFCS34Hg@mail.gmail.com>
	<CAE5mzvg9Yd2qSrpSqKTNmu08z83JmgYtGZmuLg6aYGLMei26AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvg9Yd2qSrpSqKTNmu08z83JmgYtGZmuLg6aYGLMei26AQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your help, but unfortunately, it wouldn't mount read-only,
either. If you can think of anything else I could try, it would be
greatly appreciated! Thanks!

- Liam

On Thu, Aug 18, 2011 at 8:52 PM, cwillu <cwillu@cwillu.com> wrote:
> You might try mounting it "-o ro" as a stopgap to regain readonly acc=
ess.
>
> Judging from the bootlog, the error itself appears to be enospc. =A0I=
n
> which case there's no already-available quick fix; I expect a
> developer to chime in any second now :p
>
>> From the logs it is listing a transid error but NOT that it is
>> expecting a different one, simply
>>
>> device label 1TB devid 1 transid 248472 /dev/sdb
>
> That particular line is the normal listing of devices, which is
> expected and completely normal.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
