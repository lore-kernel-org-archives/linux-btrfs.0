From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: read-only subvolumes?
Date: Wed, 23 Mar 2011 11:14:53 +0100
Message-ID: <4D89C81D.6050800@gmail.com>
References: <4D89ADA7.2000803@gmail.com> <4D89BC88.5030406@cn.fujitsu.com> <4D89C649.7080803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89C649.7080803@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 23.03.2011 11:07, Andreas Philipp wrote:
>
> On 23.03.2011 10:25, Li Zefan wrote:
>>> Hi all,
>>>
>>> When I am creating subvolumes I get this strange behavior. If I
>>> create a subvolume with a name longer than 4 characters it is
>>> read-only, if the name is shorter than 5 characters the
>>> subvolume is writeable as expected. I think it is since I
>>> upgraded to kernel version 2.6.38 (I do not create subvolumes
>>> on a regular basis.). I will compile one of the latest 2.6.37
>>> kernels to see whether there the problem exists, too. Another
>>> interesting point is that previously created subvolumes are
>>> not affected.
>>>
>>> Thanks, Andreas Philipp
>>>
>>> thor btrfs # btrfs subvolume create 123456789 Create subvolume
>>> './123456789' thor btrfs # touch 123456789/lsdkfj touch:
>>> cannot touch `123456789/lsdkfj': Read-only file system
>
>> This is really odd, but I can't reproduce it.
>
>> I created a btrfs filesystem on 2.6.37 kernel, and rebooted to
>> latest 2.6.38+, and tried the procedures as you did, but nothing
>> bad happend.
> While playing around I found the following three new points: - Now
> the length of the subvolume name does not matter. So even the ones
> with short names are read-only. - It also happens to a fresh newly
> created btrfs filesystem. - If I take a snapshot of an "old" (=
> writeable) subvolume this is writeable.
>
> I will now reboot into 2.6.37.4, check there, and then report
> back.

Well, this was fast. Everything works as expected on 2.6.37.4. See the
output of uname -a for the exact kernel version below.
I will now reboot into a differently configured kernel version 2.6.38
and look whether the problem is gone there.

Thanks,
Andreas Philipp

thor ~ # uname -a
Linux thor 2.6.37.4 #2 SMP Wed Mar 23 10:25:54 CET 2011 x86_64
Intel(R) Core(TM)2 CPU 6600 @ 2.40GHz GenuineIntel GNU/Linux
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNicgcAAoJEJIcBJ3+XkgiDRwP/jVRcrc+Qwq8D3rE50MjBox0
vy8ZKna2MXO4dl6Et8td1ikL0T91eueIjvOeaU5cS8vxknG7xqGh9k89Nd74j98a
2paWOiR49vYYhcKF1EZm6oKgHri/N/1RfLWvhXJef3POprwz3/n3YZcSDsiXcAnJ
M8RnGgYFoXNGamPorp32rR5XMln9A6Uma+cUZuaL4eitvsZ+YDsYk4XKZ/8O+cql
u5xKihRNDRqQL7LCfqfL0iJxDl3AReOdXUo8sBmo2ioLNv+syJJhhJ2XRbx7r8rM
LDWOnsBE1oCq2QuM49MDxuD4JFhCmTJ6oJotaBShcU0J0S8Dlu1URucDO7P33BOK
qBFnavR3HaUR+MRor7U+LmeYvasmhj/hUa1nx5jvMEQqeTIioQmYLdllyvHGApfy
R4n1+/L91mRr56s96DC31mF7xnSC13LVLJLG+r3ktlj9/u6B+8LAISgo1uDJX681
YQ5KkI8O+5AcAT8Hu1pwdQVC+LXDPp8HIqL59pUWD2v4zyynVqSKgCSKLJ10npLF
+NZRhSb6czNSvM0UrUBXPLq1th+ErfMNn4b6RCrAPbA4T5bejvCUUlkx7FiAMmVx
rnfiyolblNMfQ+9rY9k8zzZeJfR88wx7yS2VoZlV7n68K01GMy+NDRK203TjcX36
+Y8kUmwptiXc48H6teUN
=aSSq
-----END PGP SIGNATURE-----

