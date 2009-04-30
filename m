From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: kernel bug in file-item.c
Date: Thu, 30 Apr 2009 17:23:14 +1000
Message-ID: <3a7f57190904300023k411bf55crf527003096884a2c@mail.gmail.com>
References: <49F73F69.4010205@oel.state.nj.us>
	 <1240946633.15136.55.camel@think.oraclecorp.com>
	 <49F87A7F.7090804@oel.state.nj.us>
	 <1241027618.20099.48.camel@think.oraclecorp.com>
	 <49F89AB4.2090001@oel.state.nj.us>
	 <1241029841.20099.53.camel@think.oraclecorp.com>
	 <49F89E91.3020604@oel.state.nj.us>
	 <1241030419.20099.55.camel@think.oraclecorp.com>
	 <49F8A159.6090207@oracle.com> <49F8A4AF.3020907@oel.state.nj.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F8A4AF.3020907@oel.state.nj.us>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 30, 2009 at 5:04 AM, Marc R. O'Connor
<mroconnor@oel.state.nj.us> wrote:
>> If you can stomach it, you can get a second opinion from the bootabl=
e
>> windows memory testing iso:
>>
>> =C2=A0 http://oca.microsoft.com/en/windiag.asp
>
>
> It will be hard but I might just try it. Two versions of memtest86+ d=
ie
> in the middle of the scan. Ugh.

Also try memtester in Linux. Boot up as you normally do and give it a
fair chunk of your RAM to run on. Unlike memtest it leaves all the
actual low level stuff to the kernel. Doesn't even need root, let
alone boot. At least then you can thoroughly rule out a memtest86 bug.

--=20
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
