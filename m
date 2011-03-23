From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: read-only subvolumes?
Date: Wed, 23 Mar 2011 11:07:05 +0100
Message-ID: <4D89C649.7080803@gmail.com>
References: <4D89ADA7.2000803@gmail.com> <4D89BC88.5030406@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Andreas Philipp <philipp.andreas@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89BC88.5030406@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 23.03.2011 10:25, Li Zefan wrote:
>> Hi all,
>>
>> When I am creating subvolumes I get this strange behavior. If I
>> create a subvolume with a name longer than 4 characters it is
>> read-only, if the name is shorter than 5 characters the subvolume
>> is writeable as expected. I think it is since I upgraded to
>> kernel version 2.6.38 (I do not create subvolumes on a regular
>> basis.). I will compile one of the latest 2.6.37 kernels to see
>> whether there the problem exists, too. Another interesting point
>> is that previously created subvolumes are not affected.
>>
>> Thanks, Andreas Philipp
>>
>> thor btrfs # btrfs subvolume create 123456789 Create subvolume
>> './123456789' thor btrfs # touch 123456789/lsdkfj touch: cannot
>> touch `123456789/lsdkfj': Read-only file system
>
> This is really odd, but I can't reproduce it.
>
> I created a btrfs filesystem on 2.6.37 kernel, and rebooted to
> latest 2.6.38+, and tried the procedures as you did, but nothing
> bad happend.
While playing around I found the following three new points:
- - Now the length of the subvolume name does not matter. So even the
ones with short names are read-only.
- - It also happens to a fresh newly created btrfs filesystem.
- - If I take a snapshot of an "old" (= writeable) subvolume this is
writeable.

I will now reboot into 2.6.37.4, check there, and then report back.

Thanks,
Andreas Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNicZIAAoJEJIcBJ3+XkgiDysP/1oo770VqaEhf3F9gXq5/V3W
AkGGuRb0Upkwie5Y7L3YjCAjAJplYCemncsjqLDQVIQP6iYfmC3bLIM1GjDjMLfT
uwt89/pDte2JStW6kFx0u5i7IwYD6NO7vh3/i7+l1RB4qpZ7DAomroeHS5FFgD2M
y6hZcQ/bhiRKDv82c7YscBVE3ZgKIDPUHoNeduCGsCj8hSd4+/8PR7auGjv42a/l
C92G01cx4mMS0pmnwLUL4U54n1rbJNrKkaoQwINNW/E3fj6gQRwtI1QyDhDWnmfO
Y6c3JRtyYeWGadCaMq4SYGWvSFhG8jlR/a17ozubrLf/An14ywohx1pUZq0fPp9z
oxSlZCINhGBDSeahGQBw7szmU45lXf8N99TgaUTLiHyStnlQfcqpD5RyJUTSBOa2
VAVpMeuvjqw1ng+Tsd1r35e/WBtPQOd9aUj6r5Hcjt4oGlV0mL7oBAR/J0DjNYfl
kii8Ah+NWHFVw/pUVfWC3lzcwfqFIikvn3KVsR2X4LrOTmi6thrh0EG+eSOhfWuf
dI/agqONGzNGH73V7jFtWaEjetrhqRrr5Q22syqWfqX/AYbzTAlISHm574RPtf0G
P2r1fn/s/3FXGKo4zfTsscuvEE4LJaKFrjFxz5mW4wOz9hhFmTBox71ex538ZiMv
NfZzNRKpmXyZCm8USF/i
=b3lE
-----END PGP SIGNATURE-----

