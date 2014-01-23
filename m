Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hermes7.ccf.auth.gr ([155.207.1.45]:58521 "EHLO
	hermes7.ccf.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaAWGSx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 01:18:53 -0500
Message-ID: <52E0B291.7080608@ccf.auth.gr>
Date: Thu, 23 Jan 2014 08:11:29 +0200
From: =?UTF-8?B?zpPOuc+Oz4HOs86/z4IgzqDOrM67zrvOsc+C?=
	<gpall@ccf.auth.gr>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: 736227@bugs.debian.org, linux-btrfs@vger.kernel.org
Subject: Re: Bug#736227: linux-headers-3.12-1-amd64: general protection fault
 when using aptitude
References: <20140121090046.25804.36940.reportbug@localhost> <1390456022.3651.143.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1390456022.3651.143.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040007080808070702020202"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040007080808070702020202
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


In case this may help: Today the hard disk has reported unreadable=20
sectors, so the issue reported could be related to some kind of emerging =

disk failure.

Giorgos

On 23/01/2014 07:47 =CF=80=CE=BC, Ben Hutchings wrote:
> I'm sending this on to the btrfs developers to see if they can help.
>
> On Tue, 2014-01-21 at 11:00 +0200, Giorgos Pallas wrote:
> [...]
>> I just installed 3.12-amd64 stock kernel. It booted OK, I opened a kon=
sole
>> and just tried to installed the kernel headers.  Just as aptitude trie=
d to
>> start downloading packages, I got:
>> E: Method http has died unexpectedly!
>> E: Sub-process http received a segmentation fault.
>> and btrfs has crashed as seen in dmesg.
>>
>> It should be noted that I use btrfs without problems with 3.7-trunk-am=
d64
>> for almost a year.
> [...]
>
> The full message can be seen at <http://bugs.debian.org/736227>; here i=
s
> the crash log:
>
>> [  322.368186] general protection fault: 0000 [#1] SMP
>> [  322.368233] Modules linked in: cpufreq_userspace cpufreq_stats cpuf=
req_powersave cpufreq_conservative xt_multiport uinput ib_iser rdma_cm ib=
_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi sc=
si_transport_iscsi fuse ip6table_filter ip6table_mangle ip6_tables xt_tcp=
udp iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ip=
v4 nf_nat nf_conntrack iptable_mangle ip_tables x_tables ext4 crc16 mbcac=
he jbd2 loop firewire_sbp2 uvcvideo arc4 videobuf2_vmalloc videobuf2_memo=
ps videobuf2_core videodev media b43 joydev bcma snd_hda_codec_hdmi mac80=
211 cfg80211 snd_hda_codec_idt ir_lirc_codec rfkill snd_hda_intel snd_hda=
_codec rng_core iTCO_wdt snd_hwdep snd_pcm r852 lirc_dev iTCO_vendor_supp=
ort ir_mce_kbd_decoder snd_page_alloc snd_seq ir_sony_decoder ir_sanyo_de=
coder dell_wmi ir_jvc_decoder sm_common nand ir_nec_decoder ir_rc6_decode=
r ir_rc5_decoder nand_ecc rc_rc6_mce nand_ids mtd lpc_ich i2c_i801 dell_l=
aptop coretemp acpi_cpufreq snd_seq_device !
>>   r592 snd_timer mfd_core sparse_keymap dcdbas psmouse snd ite_cir rc_=
core memstick soundcore processor pcspkr wmi serio_raw battery ac evdev b=
trfs xor raid6_pq crc32c libcrc32c sha256_generic cbc dm_crypt dm_mod sg =
sd_mod crct10dif_generic sr_mod crc_t10dif cdrom crct10dif_common firewir=
e_ohci sdhci_pci sdhci firewire_core crc_itu_t thermal ahci libahci tg3 l=
ibata ssb mmc_core pcmcia i915 ptp pps_core libphy pcmcia_core video scsi=
_mod ehci_pci uhci_hcd ehci_hcd button i2c_algo_bit drm_kms_helper drm i2=
c_core thermal_sys usbcore usb_common
>> [  322.369458] CPU: 0 PID: 4353 Comm: http Not tainted 3.12-1-amd64 #1=
 Debian 3.12.6-2
>> [  322.369493] Hardware name: Dell Inc. Studio 1737/0P792H, BIOS A09 0=
4/14/2011
>> [  322.369534] task: ffff880036e80840 ti: ffff88009bf7e000 task.ti: ff=
ff88009bf7e000
>> [  322.369569] RIP: 0010:[<ffffffff812713e2>]  [<ffffffff812713e2>] me=
mcpy+0x12/0x110
>> [  322.369615] RSP: 0018:ffff88009bf7f968  EFLAGS: 00010202
>> [  322.369646] RAX: ffff88008e2eaf39 RBX: 0000000000000001 RCX: 000000=
0000000001
>> [  322.369679] RDX: 0000000000000001 RSI: db73880000000000 RDI: ffff88=
008e2eaf39
>> [  322.369711] RBP: ffff880131ca9770 R08: 0000000000001000 R09: ffff88=
009bf7f978
>> [  322.369744] R10: 0000000000000000 R11: 0000000000000000 R12: 6db6db=
6db6db6db7
>> [  322.369776] R13: 0000160000000000 R14: ffff88008e2eaf3a R15: 000000=
0000000001
>> [  322.369810] FS:  00007f00804a4720(0000) GS:ffff88013fc00000(0000) k=
nlGS:0000000000000000
>> [  322.369855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  322.369881] CR2: ffffffffff600400 CR3: 000000009d52b000 CR4: 000000=
00000007f0
>> [  322.369914] Stack:
>> [  322.369928]  ffffffffa034a568 0000000000000000 ffff8801378a0000 000=
0000000000000
>> [  322.369980]  ffff88013b3a9250 ffff88008e2ea000 ffff8800aa637d50 fff=
f8800925c3260
>> [  322.370032]  ffffffffa032f510 0000000000001000 ffff880131ca96a0 fff=
fea0001f1a330
>> [  322.370085] Call Trace:
>> [  322.370119]  [<ffffffffa034a568>] ? read_extent_buffer+0xc8/0x120 [=
btrfs]
>> [  322.370164]  [<ffffffffa032f510>] ? btrfs_get_extent+0x910/0x990 [b=
trfs]
>> [  322.370214]  [<ffffffffa03469b8>] ? __do_readpage+0x398/0x780 [btrf=
s]
>> [  322.370256]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 =
[btrfs]
>> [  322.370307]  [<ffffffffa0347142>] ? __extent_readpages.constprop.43=
+0x2d2/0x2f0 [btrfs]
>> [  322.370355]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 =
[btrfs]
>> [  322.370406]  [<ffffffffa0348de2>] ? extent_readpages+0x182/0x190 [b=
trfs]
>> [  322.370457]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 =
[btrfs]
>> [  322.370499]  [<ffffffff8115ba6b>] ? kmem_getpages+0x15b/0x1a0
>> [  322.370527]  [<ffffffff811554ad>] ? alloc_pages_current+0x9d/0x160
>> [  322.370565]  [<ffffffff8111dbc3>] ? __do_page_cache_readahead+0x193=
/0x240
>> [  322.370598]  [<ffffffff8111e07a>] ? ondemand_readahead+0x14a/0x280
>> [  322.370636]  [<ffffffff81113986>] ? generic_file_aio_read+0x4a6/0x6=
f0
>> [  322.370668]  [<ffffffff81172a07>] ? do_sync_read+0x57/0x90
>> [  322.370701]  [<ffffffff81172f94>] ? vfs_read+0x94/0x160
>> [  322.370726]  [<ffffffff81173a83>] ? SyS_read+0x43/0xa0
>> [  322.370759]  [<ffffffff81499b39>] ? system_call_fastpath+0x16/0x1b
>> [  322.370795] Code: 43 58 48 2b 43 50 88 43 4e eb e9 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5=
 89 d1 <f3> a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 8b 5e 18 48 8d
>> [  322.371118] RIP  [<ffffffff812713e2>] memcpy+0x12/0x110
>> [  322.371154]  RSP <ffff88009bf7f968>
>> [  322.378460] ---[ end trace 4d0836c03317ee9d ]---



--------------ms040007080808070702020202
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYpjCC
B+wwggbUoAMCAQICBQMAAAAKMA0GCSqGSIb3DQEBBQUAMIGeMQswCQYDVQQGEwJHUjEtMCsG
A1UEChMkQXJpc3RvdGxlIFVuaXZlcnNpdHkgb2YgVGhlc3NhbG9uaWtpMTswOQYDVQQDEzJB
cmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVzc2Fsb25pa2kgQ2VudHJhbCBDQSBSMjEjMCEG
CSqGSIb3DQEJARYUcGtpYWRtaW5AY2NmLmF1dGguZ3IwHhcNMTIwMTExMTQyNTAyWhcNMTYw
MTEwMTQyNTAyWjCBqzELMAkGA1UEBhMCR1IxLTArBgNVBAoTJEFyaXN0b3RsZSBVbml2ZXJz
aXR5IG9mIFRoZXNzYWxvbmlraTEpMCcGA1UECxMgQ2VudHJhbCBDb21tdW5pY2F0aW9uIEZh
Y2lsaXRpZXMxQjBABgNVBAMTOUFVVEggTmV0d29yayBPcGVyYXRpb25zIENlbnRlciBDZXJ0
aWZpY2F0aW9uIEF1dGhvcml0eSBSNDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AN01BXotdnqVCHyc04sST9gZBx8veDSHnvHXTxw01YItjl6ig1r+v8u3NLKKndRe4oWNfYH2
g2QSQ7oDhKNvF//HkrNdLeS1E83rDSl44f4m9QXc7AzF9ODTMIpz4jRPcPKb0Y4KwAw9bIRu
nK0awMgWILxlnGjtchK0mEcObuDgptTzp6C6YB1Oe7WTarYug0KBPmQMgsmu86Pf5/1agVoO
zmcxSIzuxZC933wPSytBWgBFUG9zxlq1/TNMTzs9mC+rMvLn9bZVQ0AKYvqMOyZ6/1E69K1+
nGQFySulvXX/YR1tIt9UUJdLrBY6sJ+80npQAabnKjFbsqbXveYnto8CAwEAAaOCBCAwggQc
MA8GA1UdEwEB/wQFMAMBAf8wCwYDVR0PBAQDAgEGMBEGCWCGSAGG+EIBAQQEAwIABzAdBgNV
HQ4EFgQUiUIEyKao9TzeZuew+Ol7zXJEKVUwCQYDVR0RBAIwADAfBgNVHRIEGDAWgRRwa2lh
ZG1pbkBjY2YuYXV0aC5ncjBHBgNVHR8EQDA+MDygOqA4hjZodHRwOi8vY3JsdjEucGtpLmF1
dGguZ3IvQXV0aENlbnRyYWxDQVIyL2NybHYxLmRlci5jcmwwIwYJYIZIAYb4QgEEBBYWFG5z
X3Jldm9rZV9xdWVyeS5waHA/MDcGCWCGSAGG+EIBAgQqFihodHRwOi8vY3JsdjEucGtpLmF1
dGguZ3IvQXV0aENlbnRyYWxDQVIyMDgGCWCGSAGG+EIBCAQrFilodHRwOi8vd3d3LnBraS5h
dXRoLmdyL2RvY3VtZW50cy9DUFMuaHRtbDCBmgYJYIZIAYb4QgENBIGMFoGJVGhpcyBjZXJ0
aWZpY2F0ZSBpcyBzdWJqZWN0IHRvIEdyZWVrIGxhd3MgYW5kIG91ciBDUFMuIFRoaXMgQ2Vy
dGlmaWNhdGUgbXVzdCBvbmx5IGJlIHVzZWQgZm9yIGFjYWRlbWljLCByZXNlYXJjaCBvciBl
ZHVjYXRpb25hbCBwdXJwb3Nlcy4wgcYGA1UdIwSBvjCBu4AUGG5s7dVfe8pEhyCWBdp5Dv5r
LT6hgZukgZgwgZUxCzAJBgNVBAYTAkdSMUQwQgYDVQQKEztIZWxsZW5pYyBBY2FkZW1pYyBh
bmQgUmVzZWFyY2ggSW5zdGl0dXRpb25zIENlcnQuIEF1dGhvcml0eTFAMD4GA1UEAxM3SGVs
bGVuaWMgQWNhZGVtaWMgYW5kIFJlc2VhcmNoIEluc3RpdHV0aW9ucyBSb290Q0EgMjAwNoIF
AQAAABEwMwYIKwYBBQUHAQEEJzAlMCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5wa2kuYXV0
aC5ncjCCASAGA1UdIASCARcwggETMIIBDwYLKwYBBAG8HQIAAwIwgf8wNAYIKwYBBQUHAgEW
KGh0dHA6Ly93d3cucGtpLmF1dGguZ3IvZG9jdW1lbnRzL0NQUy5waHAwgcYGCCsGAQUFBwIC
MIG5MCsWJEFyaXN0b3RsZSBVbml2ZXJzaXR5IG9mIFRoZXNzYWxvbmlraTADAgEBGoGJVGhp
cyBjZXJ0aWZpY2F0ZSBpcyBzdWJqZWN0IHRvIEdyZWVrIGxhd3MgYW5kIG91ciBDUFMuIFRo
aXMgQ2VydGlmaWNhdGUgbXVzdCBvbmx5IGJlIHVzZWQgZm9yIGFjYWRlbWljLCByZXNlYXJj
aCBvciBlZHVjYXRpb25hbCBwdXJwb3Nlcy4wDQYJKoZIhvcNAQEFBQADggEBAJThW/mkAYOB
m132rwJdzYmBPx7hpASifzpNz57/ikyHzxhzcOFllRA+bHQbUkwbPwLqqr2pP5yelU1D4EVK
oGPsvcZH/x8qXSbQ3DLqmaofn5+/pDPm8xEHjLw7qoIRvUcQTeB5ckfou9uMCZtuYwfc0AKf
TnWOtoiaLJU090LxwUS4ziMMMNaFe2zY8L0e1e1GtZ2kIjFlR0hZqN+K8ghHWRK8DD7I+hBK
IEPIV+y2E977/s4k1+sp3yOmX3LkOrzyEBCGEOnTwBMvu1bXdPdhA45vm03nuJ4cN2oSQTUf
C9mgiPgN1jht3ydecPIhlurmDstOtzoUltFo0dEJDdAwgggLMIIG86ADAgECAgUBAAAAETAN
BgkqhkiG9w0BAQUFADCBlTELMAkGA1UEBhMCR1IxRDBCBgNVBAoTO0hlbGxlbmljIEFjYWRl
bWljIGFuZCBSZXNlYXJjaCBJbnN0aXR1dGlvbnMgQ2VydC4gQXV0aG9yaXR5MUAwPgYDVQQD
EzdIZWxsZW5pYyBBY2FkZW1pYyBhbmQgUmVzZWFyY2ggSW5zdGl0dXRpb25zIFJvb3RDQSAy
MDA2MB4XDTA5MDIxODExMzkwOVoXDTE3MDIxNjExMzkwOVowgZ4xCzAJBgNVBAYTAkdSMS0w
KwYDVQQKEyRBcmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVzc2Fsb25pa2kxOzA5BgNVBAMT
MkFyaXN0b3RsZSBVbml2ZXJzaXR5IG9mIFRoZXNzYWxvbmlraSBDZW50cmFsIENBIFIyMSMw
IQYJKoZIhvcNAQkBFhRwa2lhZG1pbkBjY2YuYXV0aC5ncjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMpnF+rrLBQkgkHvNMJbTrxxEFsEKUlaqst4vQnI8qIM3heyEUBIzEII
crzMA7XhSRKa+HvQg61nerKTepZrQ7od/+ookaX4kR1H+c16pkf+6n+spKSj8rrv8W6sKqED
jiyB6JkbRNhIgt18XHWgI4Q68GK3+2H4eir+jxFMPH1cMRmJeO4rV8RXYk9pFtNSviFCk21n
ZEJj7s9hSuIpn22ysg6ZfL1umusN079/B8kwjZcS4dLmnVfo7FfWcXb719QVqFXq/wo0HYFl
cJfSF9MIjfMnQ6cr94zA3dsbTCA9LVAW0d4VK3swsvUkuUGpbLQ1oRfSTU2nBrr6traZZU0C
AwEAAaOCBFUwggRRMA8GA1UdEwEB/wQFMAMBAf8wCwYDVR0PBAQDAgEGMBEGCWCGSAGG+EIB
AQQEAwIABzAdBgNVHQ4EFgQUGG5s7dVfe8pEhyCWBdp5Dv5rLT4wHwYDVR0RBBgwFoEUcGtp
YWRtaW5AY2NmLmF1dGguZ3IwFwYDVR0SBBAwDoEMY2FAaGFyaWNhLmdyMEYGA1UdHwQ/MD0w
O6A5oDeGNWh0dHA6Ly9jcmx2MS5oYXJpY2EuZ3IvSGFyaWNhUm9vdENBMjAwNi9jcmx2MS5k
ZXIuY3JsMCMGCWCGSAGG+EIBBAQWFhRuc19yZXZva2VfcXVlcnkucGhwPzA2BglghkgBhvhC
AQIEKRYnaHR0cDovL2NybHYxLmhhcmljYS5nci9IYXJpY2FSb290Q0EyMDA2MEcGCWCGSAGG
+EIBCAQ6FjhodHRwOi8vd3d3LmhhcmljYS5nci9kb2N1bWVudHMvSGFyaWNhUm9vdENBMjAw
Ni9DUFMuaHRtbDCBmgYJYIZIAYb4QgENBIGMFoGJVGhpcyBjZXJ0aWZpY2F0ZSBpcyBzdWJq
ZWN0IHRvIEdyZWVrIGxhd3MgYW5kIG91ciBDUFMuIFRoaXMgQ2VydGlmaWNhdGUgbXVzdCBv
bmx5IGJlIHVzZWQgZm9yIGFjYWRlbWljLCByZXNlYXJjaCBvciBlZHVjYXRpb25hbCBwdXJw
b3Nlcy4wgcIGA1UdIwSBujCBt4AUuI7vRN3u+w8c/6Fkl6qSqLdwqBihgZukgZgwgZUxCzAJ
BgNVBAYTAkdSMUQwQgYDVQQKEztIZWxsZW5pYyBBY2FkZW1pYyBhbmQgUmVzZWFyY2ggSW5z
dGl0dXRpb25zIENlcnQuIEF1dGhvcml0eTFAMD4GA1UEAxM3SGVsbGVuaWMgQWNhZGVtaWMg
YW5kIFJlc2VhcmNoIEluc3RpdHV0aW9ucyBSb290Q0EgMjAwNoIBADAxBggrBgEFBQcBAQQl
MCMwIQYIKwYBBQUHMAGGFWh0dHA6Ly9vY3NwLmhhcmljYS5ncjCCAUAGA1UdIASCATcwggEz
MIIBLwYMKwYBBAGBzxEBAAEAMIIBHTAzBggrBgEFBQcCARYnaHR0cDovL3d3dy5oYXJpY2Eu
Z3IvZG9jdW1lbnRzL0NQUy5odG1sMIHlBggrBgEFBQcCAjCB2DBKFkNIZWxsZW5pYyBBY2Fk
ZW1pYyBhbmQgUmVzZWFyY2ggSW5zdGl0dXRpb25zIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
MAMCAQEagYlUaGlzIGNlcnRpZmljYXRlIGlzIHN1YmplY3QgdG8gR3JlZWsgbGF3cyBhbmQg
b3VyIENQUy4gVGhpcyBDZXJ0aWZpY2F0ZSBtdXN0IG9ubHkgYmUgdXNlZCBmb3IgYWNhZGVt
aWMsIHJlc2VhcmNoIG9yIGVkdWNhdGlvbmFsIHB1cnBvc2VzLjANBgkqhkiG9w0BAQUFAAOC
AQEAGyvmVy6kvlpM6yJwcuXXjATYx/SSeJvfq0OSAAjz74cVtLjixyRFtN/ckdLYm5izeItk
RZlb7o7KFvHnOKi39WeG9oziRwd5QFyl89G4eVBqfAZeGglgPJtBtknLXGQdFoijvE0PPC5Y
SLGObGMY7CnT7iQUoPWqeZBqzxTnne4oLLgRFkEv9/6hrLm70KvjILdgjlArUX3c7zwPbPfo
dHhkUJpK4GmDi0vBu17iSwW/ZQ5CynvIvKcK1E4SgVo7GZJ8mIpDzOsPpVrF5FgTDbUQTvxR
auNqa3yzra2YtJ56URJAaj91Utguntez0RBK+04LgiUC8E9lFlxJ9jj0rDCCCKMwggeLoAMC
AQICBQUAAABrMA0GCSqGSIb3DQEBBQUAMIGrMQswCQYDVQQGEwJHUjEtMCsGA1UEChMkQXJp
c3RvdGxlIFVuaXZlcnNpdHkgb2YgVGhlc3NhbG9uaWtpMSkwJwYDVQQLEyBDZW50cmFsIENv
bW11bmljYXRpb24gRmFjaWxpdGllczFCMEAGA1UEAxM5QVVUSCBOZXR3b3JrIE9wZXJhdGlv
bnMgQ2VudGVyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFI0MB4XDTEyMTAyOTAwMDAwMFoX
DTE0MTAyOTIxMDYyNVowgd8xCzAJBgNVBAYTAkdSMS0wKwYDVQQKEyRBcmlzdG90bGUgVW5p
dmVyc2l0eSBvZiBUaGVzc2Fsb25pa2kxIjAgBgNVBAsTGU5ldHdvcmsgT3BlcmF0aW9ucyBD
ZW50ZXIxQTA/BgNVBAsTOENsYXNzIEIgLSBQcml2YXRlIEtleSBjcmVhdGVkIGFuZCBzdG9y
ZWQgaW4gc29mdHdhcmUgQ1NQMRgwFgYDVQQDEw9HZW9yZ2lvcyBQYWxsYXMxIDAeBgkqhkiG
9w0BCQEWEWdwYWxsQGNjZi5hdXRoLmdyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA7LEEkI1rNadc26XassXANCZzxdUzpBQmBZglyn40bPnOzjGHIjUuZd5NnHhgJO27LP/r
ZGkWcFhd1orp/ED734+z5SWVc4zlHDqSTKmmxpVbxDamNwRfpypBTMTguAyk9XSkm6IMO2IT
nfCMVOr0faxoa9aNxDWDp99czWpCrhtBFOHQ3ifmpnv83epZT1Gr9xiRqHk0mBqAhpZyL1vX
HrKxR/0wIE5LR6/m7rL+SqYgCfXTYBCKgx4fsZFUY+2zdnVm14p8A/5DYZinfVx7+14XofN3
dOMMSXCxLgckJnbuH/9UgimHQ+1hzbpmvA8g+Yqm5wXdw+F7QPv8t4MzRQIDAQABo4IEljCC
BJIwDAYDVR0TAQH/BAIwADARBglghkgBhvhCAQEEBAMCBaAwDgYDVR0PAQH/BAQDAgXgMDUG
A1UdJQQuMCwGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNwoDBAYKKwYBBAGCNxQCAjAp
BgkrBgEEAYI3FAIEHB4aAFMAbQBhAHIAdABjAGEAcgBkAFUAcwBlAHIwHQYDVR0OBBYEFDlZ
kVzYQYkKA2GZyH5etT3yOsyxMIHPBgNVHSMEgccwgcSAFIlCBMimqPU83mbnsPjpe81yRClV
oYGkpIGhMIGeMQswCQYDVQQGEwJHUjEtMCsGA1UEChMkQXJpc3RvdGxlIFVuaXZlcnNpdHkg
b2YgVGhlc3NhbG9uaWtpMTswOQYDVQQDEzJBcmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVz
c2Fsb25pa2kgQ2VudHJhbCBDQSBSMjEjMCEGCSqGSIb3DQEJARYUcGtpYWRtaW5AY2NmLmF1
dGguZ3KCBQMAAAAKMAkGA1UdEgQCMAAwMwYIKwYBBQUHAQEEJzAlMCMGCCsGAQUFBzABhhdo
dHRwOi8vb2NzcC5wa2kuYXV0aC5ncjBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsdjEu
cGtpLmF1dGguZ3IvQXV0aE5vY0NBUjQvY3JsdjEuZGVyLmNybDCBmgYJYIZIAYb4QgENBIGM
FoGJVGhpcyBjZXJ0aWZpY2F0ZSBpcyBzdWJqZWN0IHRvIEdyZWVrIGxhd3MgYW5kIG91ciBD
UFMuIFRoaXMgQ2VydGlmaWNhdGUgbXVzdCBvbmx5IGJlIHVzZWQgZm9yIGFjYWRlbWljLCBy
ZXNlYXJjaCBvciBlZHVjYXRpb25hbCBwdXJwb3Nlcy4wMwYJYIZIAYb4QgECBCYWJGh0dHA6
Ly9jcmx2MS5wa2kuYXV0aC5nci9BdXRoTm9jQ0FSNDAjBglghkgBhvhCAQQEFhYUbnNfcmV2
b2tlX3F1ZXJ5LnBocD8wNwYJYIZIAYb4QgEIBCoWKGh0dHA6Ly93d3cucGtpLmF1dGguZ3Iv
ZG9jdW1lbnRzL0NQUy5waHAwggEgBgNVHSAEggEXMIIBEzCCAQ8GCysGAQQBvB0CAAMCMIH/
MDQGCCsGAQUFBwIBFihodHRwOi8vd3d3LnBraS5hdXRoLmdyL2RvY3VtZW50cy9DUFMucGhw
MIHGBggrBgEFBQcCAjCBuTArFiRBcmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVzc2Fsb25p
a2kwAwIBARqBiVRoaXMgY2VydGlmaWNhdGUgaXMgc3ViamVjdCB0byBHcmVlayBsYXdzIGFu
ZCBvdXIgQ1BTLiBUaGlzIENlcnRpZmljYXRlIG11c3Qgb25seSBiZSB1c2VkIGZvciBhY2Fk
ZW1pYywgcmVzZWFyY2ggb3IgZWR1Y2F0aW9uYWwgcHVycG9zZXMuMDMGA1UdEQQsMCqgKAYK
KwYBBAGCNxQCA6AaDBhncGFsbEBwY2xhYnMuaXRjLmF1dGguZ3IwDQYJKoZIhvcNAQEFBQAD
ggEBAH3EpJe2t53EqQPiFntEcE8i4HTsDmSyz9/UW+8rDU2aff0RaGKguU8e97m3N12LN5Yn
GgNFwESwDTCW3wUJpWTZEozzkY0ArOSpneJJ6YjSp45XfRUmowH+ZX9aFVKvNUwF88AYHRDT
/QvLYSepEojcS4JcXP23MwLvwc8cVsVFJnrh5EavcrTpEpqqwkhcCubUMBqg2gUJ3GSQsCF2
OjwB2Y2Xek3QbW2LUaFq+YIeIt9ewcFGm2Dp3+L9nLpXMiHnfpKYV8ipFu4DLFlO4zllNS4C
WesDlwJshlVAg3ku2ppSRaUVMtkZ5VsiC+m4Bo5KSsGzB27n8aeij0vKAAwxggRAMIIEPAIB
ATCBtTCBqzELMAkGA1UEBhMCR1IxLTArBgNVBAoTJEFyaXN0b3RsZSBVbml2ZXJzaXR5IG9m
IFRoZXNzYWxvbmlraTEpMCcGA1UECxMgQ2VudHJhbCBDb21tdW5pY2F0aW9uIEZhY2lsaXRp
ZXMxQjBABgNVBAMTOUFVVEggTmV0d29yayBPcGVyYXRpb25zIENlbnRlciBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eSBSNAIFBQAAAGswCQYFKw4DAhoFAKCCAl8wGAYJKoZIhvcNAQkDMQsG
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwMTIzMDYxMTI5WjAjBgkqhkiG9w0BCQQx
FgQUsXYdwLGQALJ7q5iU+ddoOITYG+owbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASow
CwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIB
QDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBxgYJKwYBBAGCNxAEMYG4MIG1MIGrMQswCQYD
VQQGEwJHUjEtMCsGA1UEChMkQXJpc3RvdGxlIFVuaXZlcnNpdHkgb2YgVGhlc3NhbG9uaWtp
MSkwJwYDVQQLEyBDZW50cmFsIENvbW11bmljYXRpb24gRmFjaWxpdGllczFCMEAGA1UEAxM5
QVVUSCBOZXR3b3JrIE9wZXJhdGlvbnMgQ2VudGVyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
IFI0AgUFAAAAazCByAYLKoZIhvcNAQkQAgsxgbiggbUwgasxCzAJBgNVBAYTAkdSMS0wKwYD
VQQKEyRBcmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVzc2Fsb25pa2kxKTAnBgNVBAsTIENl
bnRyYWwgQ29tbXVuaWNhdGlvbiBGYWNpbGl0aWVzMUIwQAYDVQQDEzlBVVRIIE5ldHdvcmsg
T3BlcmF0aW9ucyBDZW50ZXIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgUjQCBQUAAABrMA0G
CSqGSIb3DQEBAQUABIIBACvB2EUE6xY5Qv8XZeJeqLXGCFm/tTJcXJz2fX2cCZJ7hAyD9MEK
eybSMti5+u6gl5YQ4z7pFKEw7kDioBt0a8bz+Q2XigvRAJqGKZb0oEZbOpcA/6HDrWBC0v1H
ZRq2OBP8Jc4HSvrNMomGdREZv5bZuvuVQKaed8Ym2kL85WKB0TbUITNewCHfxx06bkq6PGf0
OJ6jzNdsBGuc8pVFYXiu07tZZwI0xFuRvhDd8T+MDuSZJnHQJ2Tq5dMq8ijpz0MKkOTkF+5P
8Y1xFQKoFkoAt4WM591oKGRlAoN9FXYy24RFS4H5ZUF4UHEAFFH9PYw2zZU+AZ3kammH68Xz
kI8AAAAAAAA=
--------------ms040007080808070702020202--
