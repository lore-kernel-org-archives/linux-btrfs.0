From: Edilson Osorio Junior <ed.junior@oztechnology.com.br>
Subject: Btrfs problem - trace attached
Date: Wed, 18 Jan 2012 17:34:02 -0200
Message-ID: <4F171EAA.2000201@oztechnology.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigAADBA798544C9D5A21D8074C"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAADBA798544C9D5A21D8074C
Content-Type: multipart/mixed;
 boundary="------------060505030306010801060604"

This is a multi-part message in MIME format.
--------------060505030306010801060604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

I got this kernel dump when trying to remove some files.

Now, when I try to access the directory, or any file there I get:

---
[xxx@tyler vbox]$ ls
ls: cannot access machine: Stale NFS file handle
harddisk  machine
[xxx@tyler vbox]$ cd machine
bash: cd: machine: Stale NFS file handle
[xxx@tyler vbox]$ ls -la
ls: cannot access machine: Stale NFS file handle
total 0
drwxrwxr-x 1 root root  30 Dec 22  2010 .
drwxrwxr-x 1 root root 112 Jan 18 16:29 ..
drwxrwxr-x 1 root root 154 Jan 18 16:30 harddisk
d????????? ? ?    ?      ?            ? machine
---

On time: that is a local directory, that's not mounted over NFS at all.

---
My system:
Fedora release 15 (Lovelock)
Linux tyler.xxx 2.6.41.9-1.fc15.i686.PAE #1 SMP Fri Jan 13 16:35:57 UTC
2012 i686 i686 i386 GNU/Linux

Btrfs mount over raid0

[xxx@tyler vbox]$ cat /proc/mdstat
Personalities : [raid0]
md0 : active raid0 sdb1[0] sdc1[1]
      312573952 blocks super 1.2 512k chunks

unused devices: <none>
[xxx@tyler vbox]$ mount
[cut]
/dev/md0 on /installed/utils type btrfs (rw,relatime)
[cut]
---


Hope it could be helpful to deploy.

Best regards,
Edilson



--=20
------------------------------------------------------------------------


*Edilson Osorio Junior*
Chief Information Officer

*OZ Technology*
Phone:  +55 11 3892-8272
email:   ed.junior@oztechnology.com.br
<mailto:ed.junior@oztechnology.com.br>
www:    www.oztechnology.com.br <http://www.oztechnology.com.br>
[restrito]



while (!(succeed =3D=3D try()))
*P* *Antes de imprimir pense em seu compromisso com o Meio Ambiente**//**=
P*

------------------------------------------------------------------------




As informa=E7=F5es contidas nesta mensagem podem ser confidenciais e/ou
privilegiadas. Se voc=EA n=E3o =E9 seu o destinat=E1rio final ou n=E3o es=
t=E1
autorizado a receb=EA-la em nome do destinat=E1rio, fica expressamente
vedado o direito de copiar, divulgar ou utilizar as informa=E7=F5es nela
contidas. Caso tenha recebido esta mensagem por engano, favor entrar em
contato com o autor, utilizando endere=E7o de correio ou telefone, e
comunicar o ocorrido, removendo-a em seguida. Obrigado pela coopera=E7=E3=
o.

This message may contain confidential and/or privileged information. If
you are not the address or a third-party person authorized to receive
this for the address, you must not use, copy, disclose or take any
action based on this message or any information here . If you have
received this message in error, please advise the sender immediately by
replying this e-mail and deleting this message. Thank you for the
comprehension.

--------------060505030306010801060604
Content-Type: text/plain;
 name="btrfs-trace-20120118.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="btrfs-trace-20120118.txt"

Jan 18 16:20:03 tyler kernel: [103530.372167] btrfs: corrupt leaf, bad ke=
y order: block=3D155084496896,root=3D1, slot=3D13
Jan 18 16:21:33 tyler kernel: [103620.374871] device eth0 entered promisc=
uous mode
Jan 18 16:31:51 tyler kernel: [104236.059293] ------------[ cut here ]---=
---------
Jan 18 16:31:51 tyler kernel: [104236.059328] kernel BUG at fs/btrfs/tran=
saction.c:1244!
Jan 18 16:31:51 tyler kernel: [104236.059361] invalid opcode: 0000 [#1] S=
MP=20
Jan 18 16:31:51 tyler kernel: [104236.059392] Modules linked in: tcp_lp f=
use nfs lockd fscache auth_rpcgss nfs_acl tpm_infineon vboxpci vboxnetadp=
 vboxnetflt sunrpc vboxdrv ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 x=
t_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc=
32c raid0 snd_hda_codec_hdmi snd_hda_codec_realtek ppdev gspca_zc3xx gspc=
a_main videodev microcode media i2c_i801 serio_raw joydev snd_hda_intel s=
nd_hda_codec snd_hwdep snd_seq snd_seq_device sundance mii snd_pcm iTCO_w=
dt iTCO_vendor_support snd_timer snd soundcore snd_page_alloc e1000e parp=
ort_pc parport virtio_net kvm_intel kvm ipv6 pata_acpi ata_generic i915 d=
rm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: mperf]
Jan 18 16:31:51 tyler kernel: [104236.059902]=20
Jan 18 16:31:51 tyler kernel: [104236.059915] Pid: 853, comm: btrfs-trans=
acti Tainted: G         C  2.6.41.4-1.fc15.i686 #1                  /DH55=
HC
Jan 18 16:31:51 tyler kernel: [104236.059982] EIP: 0060:[<fa3a418f>] EFLA=
GS: 00010282 CPU: 0
Jan 18 16:31:51 tyler kernel: [104236.060034] EIP is at btrfs_commit_tran=
saction+0x1f0/0x68d [btrfs]
Jan 18 16:31:51 tyler kernel: [104236.060071] EAX: fffffffe EBX: f2049000=
 ECX: fffffffe EDX: 00040e92
Jan 18 16:31:51 tyler kernel: [104236.060108] ESI: 00000000 EDI: 00000000=
 EBP: f2699f84 ESP: f2699f38
Jan 18 16:31:51 tyler kernel: [104236.060146]  DS: 007b ES: 007b FS: 00d8=
 GS: 00e0 SS: 0068
Jan 18 16:31:51 tyler kernel: [104236.060179] Process btrfs-transacti (pi=
d: 853, ti=3Df2698000 task=3Df2127110 task.ti=3Df2698000)
Jan 18 16:31:51 tyler kernel: [104236.060226] Stack:
Jan 18 16:31:51 tyler kernel: [104236.060240]  00000000 00000298 00000000=
 d726c2b8 cd4926f0 d726c260 00000000 f2127110
Jan 18 16:31:51 tyler kernel: [104236.060304]  c04548b1 f2699f5c f2699f5c=
 00000000 00000000 f2049000 f2127110 00000000
Jan 18 16:31:51 tyler kernel: [104236.060367]  f2049000 f2127110 00000000=
 f2699fb8 fa39ef14 000086dc f2127110 f2699f9c
Jan 18 16:31:51 tyler kernel: [104236.060431] Call Trace:
Jan 18 16:31:51 tyler kernel: [104236.060453]  [<c04548b1>] ? remove_wait=
_queue+0x2c/0x2c
Jan 18 16:31:51 tyler kernel: [104236.060500]  [<fa39ef14>] transaction_k=
thread+0x138/0x1d3 [btrfs]
Jan 18 16:31:51 tyler kernel: [104236.060540]  [<c07f9f2b>] ? _raw_spin_u=
nlock_irqrestore+0x13/0x15
Jan 18 16:31:51 tyler kernel: [104236.060591]  [<fa39eddc>] ? btrfs_conge=
sted_fn+0x68/0x68 [btrfs]
Jan 18 16:31:51 tyler kernel: [104236.060627]  [<c04543ac>] kthread+0x67/=
0x6c
Jan 18 16:31:51 tyler kernel: [104236.060654]  [<c0454345>] ? kthread_wor=
ker_fn+0x11d/0x11d
Jan 18 16:31:51 tyler kernel: [104236.060688]  [<c080023e>] kernel_thread=
_helper+0x6/0x10
Jan 18 16:31:51 tyler kernel: [104236.060721] Code: 00 00 89 d8 e8 85 c1 =
00 00 31 d2 b9 01 00 00 00 89 d8 e8 99 60 01 00 85 c0 74 02 0f 0b 8b 45 c=
4 89 da e8 d9 87 03 00 85 c0 74 02 <0f> 0b ba 01 00 00 00 89 d8 e8 fb 64 =
01 00 8b 45 c0 8d 55 cc b9=20
Jan 18 16:31:51 tyler kernel: [104236.061012] EIP: [<fa3a418f>] btrfs_com=
mit_transaction+0x1f0/0x68d [btrfs] SS:ESP 0068:f2699f38
Jan 18 16:31:51 tyler kernel: [104236.122706] ---[ end trace 324e53d6be74=
0fbd ]---


--------------060505030306010801060604--

--------------enigAADBA798544C9D5A21D8074C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPFx6qAAoJELDEcvLloukxAuYQALfSNFvwhu0tYeJ3Eez2DNaS
rwIesEc+EFXnZRj+Z62H5xST/cSdl6579Eylp7wNVvI6xt0pc3tkI0OkGSLk6szJ
0nvqai4wcEpTYFKfUZpgv7X2qzLfku3XKiDvjP2l8bSNTKxE/e1qyPpRxI2ebCa5
nKu4wD8J4KLp+Qn2skF7iFtvE/A8oCAsnLDPPKYqrzfKbva3DdiV/BO9ZGPalznl
zzRie4nYveTB/ruo+bt/BEYt9pqB9qAiQwQfd2lH8eTWIccz21cj4Cc47ODQ8WIg
PNMtUDqwY6od3ZGE7DDgum87jWuPQ1a9dsEfJw4axbQYRfnn6S5B0ZnZgtAp/IsB
/ikWJy7AzbuqzKnuarmUAUNjP3PSxJAtDj8J0SNZxUXCibMBcw6TKt5n56EdGFu4
YTFqo9CXl87JM/xqSHGlMiJwzCPkaIkp19mu/+EiZ20VwIRGYlxX+myyt0llQl0h
XQRj4BSxPAS9CZdKQI7AWKdPMUHmpfdS5ruifCvm3sCyHOtw1SKu5jhZ8rpiNW0k
QrxFO3siW9VhCsW0vn4ONGHw2pYdKoNk+Dw76GSGwFGXql6M8/msD3F8liBpWlzk
xN23wTth6a/HKsZK//YqiHPi64W5dpexeffZMvVAQmHS8n8JN+0Qv5fiNOXpQvTq
wQSxEQRwVJD/edoRmHdB
=PomM
-----END PGP SIGNATURE-----

--------------enigAADBA798544C9D5A21D8074C--
