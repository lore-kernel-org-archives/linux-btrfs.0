From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: strange filefrag output on btrfs
Date: Tue, 14 Jun 2011 09:11:44 +0200
Message-ID: <4DF709B0.60805@gmail.com>
References: <4DF38C23.7010603@gmail.com> <20110613115018.GT12709@twin.jikos.cz> <4DF629DA.4050300@gmail.com> <4DF6CD61.6050102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF6CD61.6050102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 14.06.2011 04:54, Li Zefan wrote:
> Andreas Philipp wrote:
>>
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>
>> On 13.06.2011 13:50, David Sterba wrote:
>>> On Sat, Jun 11, 2011 at 05:39:15PM +0200, Andreas Philipp
>>> wrote:
>>>> On one of my btrfs volumes I see a strange output from
>>>> filefrag when run against a particular large (~8GB) file.
>>>> filefrag and filefrag -v give me a different number of
>>>> extents, see below.
>>>>
>>>> aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img | grep
>>>> extents funtoo.img: 2624 extents found aph@thor /mnt/nutshell
>>>> $ sudo filefrag funtoo.img | grep extents funtoo.img: 2653
>>>> extents found
>>>
>>> is the file open and being written to? did you run sync before
>>> the first command?
>> The file is not open. Yes, I have run sync before the first
>> command. Now, I tested again with a copy of file but the results
>> is more or less the same.
>>
>> aph@thor /mnt/nutshell $ cp funtoo.img funtoo.1.img aph@thor
>> /mnt/nutshell $ sync aph@thor /mnt/nutshell $ sudo filefrag -v
>> funtoo.img funtoo.1.img | grep extents funtoo.img: 2624 extents
>> found funtoo.1.img: 57 extents found aph@thor /mnt/nutshell $
>> sudo filefrag funtoo.img funtoo.1.img | grep extents funtoo.img:
>> 2653 extents found funtoo.1.img: 311 extents found
>>
>
> If you look into the source code of filefrag, you'll know why.
>
> There are two ways to calc the extent number, depending on whether
> verbose option is turned on or not.
>
> In the verbose mode, it will check if the next extent is adjacent
> to the prev extent in the physical position, and in this case they
> are considered to be one extent.
>
> That's why the number returned in verbose mode is smaller.
Thank you for this explanation.

Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN9wmvAAoJEJIcBJ3+XkgiIWgQAL0+SLwnc6V6nar30rG6wCt+
czTTy7wFgdP5oYby9NMj2a5YifxG2XBa+Hnw3doLSxTHv4i7WqouaFeT4OotBzb+
jV8GBAn3vRyGlV0mfEx1PHzqUJNzUpJHZpWKvKx4JW91z3gZ/FdXEhbZXNyTVvPm
WtaLXz71CMtCSy81TN437T92H7yvv4SxiRubbe+IuBpKCJaIA1eH2yoJ+72yDNKH
TS74hvfYoDXngxZry4EA2/3mGTOq3PMSljWBw76pqx47KhsZged0ZN+YA8th7iiK
H3Pm3m19yzvt5niA5aS/ilwR50pKE2LI2dq7kkc2yjol/A86iUmIkAEm94Bv7a/3
hdBHslzqZpb2sWaQB2qjDA9aWGyDld3B2C1a+CiYSr0kqtPRlWKPPCQiDNibxrMp
cC2vT92OCoJMnsz7OC3nQN+UZAzBTnx7deFVAlgxnLrsuVT2IZMfxeurTLGJy0vG
zygp7pXdLbj4pzvLcIbf53DQ8wsSfQfLlMDec7wj+TpDLWCuBLQRVmWIKsc1ovMb
epoBihD4xJZguaeQAsyxBuFgYNoWCj0ebxWejGIYvilCZ8SJflN8/dEN3HaT8haR
9k6qdNB9cNULggs4dN8zvB530InDNxJHuI67hRcdLs+VDcWHjCdXmfcgn3Lz5km4
wDAlG4uZi/T5Pqz1Eqvq
=NrYD
-----END PGP SIGNATURE-----

