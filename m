Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35510 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbJEMa3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 08:30:29 -0400
Received: by qgt47 with SMTP id 47so147485107qgt.2
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 05:30:28 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.googlemail.com with ESMTPSA id q140sm11121382qha.5.2015.10.05.05.30.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2015 05:30:26 -0700 (PDT)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Issues with unmountable BTRFS raid1 filesystem
Message-ID: <56126D59.7070505@gmail.com>
Date: Mon, 5 Oct 2015 08:30:17 -0400
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030206000005070308080905"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030206000005070308080905
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

I've been having issues recently with a relatively simple setup using a=20
two device BTRFS raid1 on top of two two device md RAID0's, and every=20
time I've rebooted since starting trying to use this particular=20
filesystem, I've found it unable to mount and had to recreate it from=20
scratch.  This is more of an inconvenience than anything else (while I=20
don't have backups of it, all the data is trivial to recreate (in fact,=20
so trivial that doing backups would be more effort than just recreating=20
the data by hand)), but it's still something that I would like to try=20
and fix.

First off, general info:
Kernel version: 4.2.1-local+ (4.2.1 with minor modifications, sources=20
can be found here: https://github.com/ferroin/linux)
Btrfs-progs version: 4.2

I would post output from btrfs fi show, but that's spouting obviously=20
wrong data (it's saying I'm using only 127MB with 2GB of allocations on=20
each 'disk',  I had been storing approximately 4-6GB of actual data on=20
the filesystem).

This particular filesystem is composed of BTRFS raid1 across two LVM=20
managed DM/MD RAID0 devices, each of which spans 2 physical hard drives. =

  I have a couple of other filesystems with the exact same configuration =

that have not ever displayed this issue.

When I run 'btrfs check' on the filesystem when it refuses to mount, I=20
get a number of lines like the following:
bad metadata [<bytenr>, <bytenr>) crossing stripe boundary

followed eventually by:
Errors found in extent allocation tree or chunk allocation

As is typical of a failed mount, dmesg shows a 'failed to read the=20
system array on <device>' 'open_ctree failed'.

I doubt that this is a hardware issue because:
1. Memory is brand new, and I ran a 48 hour burn-in test that showed no=20
errors.
2. A failing storage controller, PSU, or CPU would be manifesting with=20
many more issues than just this.
3. A disk failure would mean that two different disks, from different=20
manufacturing lots, are encountering errors on exactly the same LBA's at =

exactly the same time, which while possible is astronomically unlikely=20
for disks bigger than a few hundred gigabytes (the disks in question are =

1TB each).


--------------ms030206000005070308080905
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA1MTIzMDE3WjBPBgkq
hkiG9w0BCQQxQgRA/fdh9Jq/2g/y9W6inMlu6MpPgIHq6OnpDXWeuwsMP+ioPslbd3bgMmR+
lNC/NRx4PvFlrGvd0DiUxpHgpiTKVjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBRhQvZ5xTrFvI+xttFepMjT35jv6JkWbaoTmFW+2WhNxiIfyz5
9vcXbzyU2F+89oGoQvXM37chmAvmGm3wedWp0nmLk6HGJdxvB3Q72z3xnbZ1jd44F0EVc8Eh
M+Pe5xkZY+g0T6hbmb0d/x5yp+dRttCMQ06IkfrlbBRZ8ivxc9e/i262DOn6mNR2c8he0vIu
6v6vhfWArJ2ZBzhwWfqQ2fyXetF01yDvt+3LNhyL1TMHdAuvqRxP0833/N4OSYJH7FJJcLXQ
5LxwqgZgZH+Ytd3qpAhYd9o1r6Qa0hPA6/uPNyfJIFSWdV3TrnTiXSCzQLj5ZGD/4AfMwZ1O
QQBZ5uzRRrE7VYv4xqprg+0HlsDB5nM7gotvR6SQs9XZgmED1jVllk08iRbH5ULgKXdC+u/t
hbw4AkKKRaGnsnPku4S4ZzrWxXd2f5Avb9KMhv7mfDuZRwj14jw7PU4gj/YuwaRXE0jr8Frb
vz3Dq0KIoC/xWQ5ZkVHKpo4+Yg9nJD5dxFEiFNbM+7AItZyL4V8B8hyWeAjGL+jfzsFAABzZ
mIOeChEuFkyEPTSVYo2f/8yJRosCygTPeuTCwfQX+Vapa+h4lAKHexNr2CwrZDdLdNoi19Sy
uhgUoXVOHfJew65pUPc1fcyKKFj5uyLv0VhBwQQI/YBHXQEU/SRwAnugeAAAAAAAAA==
--------------ms030206000005070308080905--
