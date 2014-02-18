Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6746 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688AbaBRN6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 08:58:18 -0500
Message-ID: <530366F2.2010009@fb.com>
Date: Tue, 18 Feb 2014 08:58:10 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Goswin von Brederlow <goswin-v-b@web.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC with 270GiB free
References: <20140216135808.GA1491@frosties>
In-Reply-To: <20140216135808.GA1491@frosties>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/16/2014 08:58 AM, Goswin von Brederlow wrote:
> Hi,
> 
> I'm getting a ENOSPC error from btrfs despite there still being
> plenty of space left:
> 
> % df -m /mnt/nas3 Filesystem         1M-blocks     Used Available
> Use% Mounted on /dev/mapper/nas3-a  19077220 18805132    270773
> 99% /mnt/nas3
> 
> % btrfs fi show Label: none  uuid:
> 4b18f84e-2499-41ca-81ff-fe1783c11491 Total devices 1 FS bytes used
> 17.91TiB devid    1 size 18.19TiB used 17.94TiB path
> /dev/mapper/nas3-a
> 
> Btrfs v3.12
> 
> % btrfs fi df Data, single: total=17.89TiB, used=17.88TiB System,
> DUP: total=32.00MiB, used=1.92MiB Metadata, DUP: total=25.50GiB,
> used=24.89GiB
> 
> As you can see there are still 270GiB free and plenty of block
> groups free on the device too.
> 
> So why isn't btrfs allocating a new block group to store more
> data?
> 
> 

What kernel?  Can you give btrfs-next a try?  Mount with -o
enospc_debug and when you get enospc send the dmesg.  Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTA2bsAAoJEANb+wAKly3BLB4P/0W5RCk9YZQ+WJcDs8/g82Be
G5oWx+0N2eYKIttCWxrvXlx2mpVP5mWimzYqs+V7SvaVgbm3KlwuID9JQpuOQ1lH
ihnxr48kdwNa8J159oEU7oVRJ84D1b0D21MZzIKU9YoNoDHTQQsELe4aojniKMIY
4RFh/8qWjMm2BGKW4jZwKzIHoF9rt+kU7Lhfm9XOi0OCut8FlFSjSwsiaN8NFJAf
DFtkgfZTRJUxiq3dXn7m6yzspS3L5atAfd862UbFDrA7EcYIZnc+zw9/hUxX8JwP
N3espmJQ03DRn8LLoOZtBMZ+NUnRgoOd33k1z9jeB7RnqN165vSQaYibUw6Zk+Vh
qADBAy+f8aHtBF8yNIuwqEXH9D5fXlfgYUnWW/YBiw6+dbguxb4CKIzkdh67paah
zvpLrXkZd95taqXFkaj0PZydwSVkSIbrPuNllRku02Bz8XxPjE0rlW+wCr2uHI2y
Ne2jpGdCClJCfLTZC8SsHaLeYktvEVBnQ6ZOriU+Rl1hzvi+ieG7leRHIa1K7VED
669zuZ4QfYvdU7lnXzTuC36NmmaSC4wrLaYTPAytU4OLB5dIby9nyF+25t60hq5n
pb2R5tn7heH9928aVktFMTuAWUBTI7B1O1ZGB/cTcYKduYXOD9Y5ljEalA7HhUpb
PwuiepAP1uBkiBPQDYH1
=tCLT
-----END PGP SIGNATURE-----
