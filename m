From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: machine gets unresponsive during btrfs balance
Date: Thu, 26 Aug 2010 15:39:25 +0200
Message-ID: <4C766E8D.7000103@gmail.com>
References: <4C639F42.3050206@gmail.com> <AANLkTi=B2dr45WmeJop_Te5t55d0trfHP+ZKLE3tBxTg@mail.gmail.com> <4C65C32B.1060109@gmail.com> <201008261527.54056.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: "Yan, Zheng " <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201008261527.54056.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 26.08.2010 15:27, Johannes Hirte wrote:
> On Saturday 14 August 2010 00:11:55 Andreas Philipp wrote:
>> On 12.08.2010 10:04, Yan, Zheng wrote:
>>> On Thu, Aug 12, 2010 at 3:14 PM, Andreas Philipp
>>> <philipp.andreas@gmail.com> wrote:
>>>   
>>>> Hi,
>>>>
>>>> I am using a btrfs filesystem created with raid0 for data and metadata
>>>> for (temporary) storage of tv recordings from my vdr. The filesystem was
>>>> created under kernel version 2.6.34. An initial btrfs balance command
>>>> succeeded. Since I upgraded to 2.6.35-rcX and 2.6.35 btrfs balance no
>>>> longer finishes but puts the machine in some unresponsive state.
>>>> Unfortunately, I do not see any kernel oops or other debug information
>>>> because even the display freezes. The last thing that happens are that
>>>> those two lines are written to /var/log/messages:
>>>> Aug 11 21:42:23 thor kernel: btrfs: found 62911 extents
>>>> Aug 11 21:42:24 thor kernel: btrfs: relocating block group 1723913469952
>>>> flags 9
>>>> After that the machine becomes immediately unresponsive.
>>>>
>>>> As I did not see anything that might be related to my problem in the
>>>> changelog for 2.6.35.1 I did not try again with this version.
>>>>
>>>>     
>>> Do you have more than one machines? would you please setup netconsole
>>> to see what happen.
>>>   
>> I have reproduced the error on v2.6.35.1 and recorded all kernel output
>> with netconsole. The interesting point is that this time the machine did
>> not crash but the btrfs balance segfaulted at exact the same position
>> where the previous crashes had happened.
> 
> Looks like another manifestation of the csum bug. Are you able to read all 
> files from the affected volume? Did you tried a balance with an 2.6.34 kernel 
> after the test with 2.6.35?
> 
Till now I did not see any unreadable files but I did not do a
complete test. No, I did not try to balance with an 2.6.34 kernel. If
it helps I can switch back and try.

Yours,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJMdm6MAAoJEJIcBJ3+Xkgi9vUQALX7V6fOs+DJR9NGRr21uY1a
/tFj5e1r71Mryn6uFcnb2Iukf6oNirxc3n4XcSgfel/GppTPAt+s8a3jS048SNa1
XpPhpuA5j9vtPns46ZR5Bg9rTtAIa7oDO8Ko2lewnHcrZN9qoGyroTz+eIzqv/U/
N8BmGTKTE1TwKfETE8jVXXHvsQuV6vYeOJqtWzPkETw9gldHThTSvr3pl7+46yFT
iCv5n/IHsdAyeZpSJm1Jp3xxAGZJsrkhoKiyNcHHt7+UshcKpFYky4lOCAlDgpPO
quZhEHiYKUeHGYb8vueaebCgy2panrYcnEgwoGkI7XLPvTlWY/5uUgV/54rlUdwi
jqo+zgyNaBnEwUkqTAPzqZQBYb7XA5uJS7UchFhf5rpgFZeEX+gUnNYtEtUkkYLk
9vAAeXl8OyNJnBAH97/FBpRw0nVYpXeuE8/dvc1TfbHDjkOQLlgEYg3T4PW+NgsV
IwVOChoFPEmyFndAvONphTmUQjzGMJu2Y+3p9D7ZDRQOo8AHjGrErWPY+zGkZkd1
MtFCIKeTyOoR+13U4xAxi+2alGf7UE0jdxoGMQPnh7COjOYpUgMt1zFnksxn6yY+
RcFEWJSoBkOPMePxzJUTOCVb/Qr4V6HCJNEylBxF1VsECAOkjTSxl4XTAXrLKYVu
pllFS2PYozhZMoKrDKQE
=ldPn
-----END PGP SIGNATURE-----
