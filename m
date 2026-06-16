Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB15349CF0
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781648631; cv=pass; b=X6fK6dJd0EPECPhcqPQE8K/b5Uzwz83JbUib2REC0RZtAgucsu4i3xLganeneCZdP18IJYjl7XKTFJE0xUtV9cw6cbuLbzlW40DMrWNCMrn0pwJrnVjxX9hSPQCN1Kz5BtIsON1HzdVopvbu1sn37G01mssURjFyWTUkdhBjOTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781648631; c=relaxed/simple;
	bh=1396+kvytC4KyCIG8u4gZxRisc4nZ7riJUh+uES67C4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=XQ+L1SZg+dn/w+jRPnIuVst7AcM9Lm4lscJ7DOMuejeY1mYkaSIqDHzvU75RR/KMq+zcutyhP+jd/C8CyhieCqkbV6wE6qmgKHKBurZMBooqekgYrSyfsnHgAI9jOCiqfgWfrjK7XlRxhix8hdLvGxkXHzdyBgWWVkOoI6hDwAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHustSOO; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHustSOO"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-135e7f4a295so261425c88.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 15:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781648629; cv=none;
        d=google.com; s=arc-20240605;
        b=gaHx2Nczd+Ub+PJ4y44pHoNIKdGy4WdmRmBYWLKLUsrJcV3NOwgmAXbLkd/dq7pPWK
         72VeVlEoGtxAUk2Y+KKr2OVwLbhGA2JWo89bKA2dd+sg2+hzKg1f9yhkIPaem6+LJGyr
         8UCvWZvvxjIqTc9h8StJpzjUfFkYx91/ei6jdesKsD+tmX1lygS7UbiLzFV3NodyWwjo
         g3Y6MRkdjCVKPg3kcYdB8BU6i9nW8gqOsVMloegqkhm46LrlUmjwWo/B5GdtNyZnnceD
         DL+lixBD87PCxZW9dIoi9pjxG7SfRWDfE5mu0oRddOXdnB1zZK1lFRasiUGbrGNLGad2
         2eog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=1396+kvytC4KyCIG8u4gZxRisc4nZ7riJUh+uES67C4=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=fFZYPgr9SPOrpjfwonCgzT0wuNt93zG54dk9WaGeCgrkjOt9m/1k7p/4RLm9GRrGJe
         U/evtuZ2k/OiIkwCsPif4pUS0KqZv2WXonuENYCfAFMO08EmAHWaJJDyKYsEb6aKCRob
         epMBwN+L1N9AiUP3ebHn80mWQdbml8Xox/PxMkuKTCCZX3M+zHXATNsoGIk+GjiDDvL/
         PGpk0zA1WdlmAuQLGY5LVUOCAkslP5XQAfIjZ4c5nqcCJpIBL28VipV3iNaCvRQcMaJK
         4RcSHCPFIAzfVqZc0Lawsf8/rPa0jwdCjUAUnbaSE/+vhGCabnGRnbYV/Rb5hfO/svRr
         io6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781648629; x=1782253429; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1396+kvytC4KyCIG8u4gZxRisc4nZ7riJUh+uES67C4=;
        b=ZHustSOOhJhY/IAtUI9qVx80E27oB0rYOnVPWlGLN3Jafb+hwAgYX3vbSYRQ9yTU78
         8GbCJI9d2gnpXtRo4bZqFFESCNAkhRCnysCfC3hetav6+WgkRE7/6eSukqRAZf5JVrFh
         TQ3fYyMqL27tH3cjSfZLRrrHk9331l8k76by+R8u4vUaco+pqSyWKpQ7iySmqLYtc27b
         hMPmql0x+A8vSvcxe+AFygIiBigBVcRTKW4aOtecvEvhQ8Nt1+6ZadIXd6GM+iy4NTCB
         1JCjhGTl4gOlvyni0/NxhtcnJSjRP9d95maJMIUKuYpxpjZspJH0UfD18dg4mq4vvXKO
         8JpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781648629; x=1782253429;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1396+kvytC4KyCIG8u4gZxRisc4nZ7riJUh+uES67C4=;
        b=A6MznSnKhw9yu6PMPooM8LG9ohkyqVu2Ju3GD/MJMRx2Kzq5XYLuSp6s0PeIBqoRa5
         lrwYrEFfYnfic3T1mm+jm63yyTk4GULW6HUfPon8I6siRxPcqJMBl+hrG//yx9iH/vzU
         EjRfT1fBFoDoH4H5x4dOdIMJLcKY56mj7UWFMcOvbcJqb9fa3MItk3ehEwwISpyyB2pX
         ZuIQuEbAvL2Ak+zFw+cTGwUuTUiPE9SUnTeZXlM7uoDVAkQKBjK9XG5DDp0cb5iCVOCo
         FVU52Es48UCnIbBYGylJZJW+tC5nzpwn5EVh2JJFVAKZ06rDV3f322yR3Fmz+M3mV7AF
         ATog==
X-Gm-Message-State: AOJu0Yz/VcDx+JUAgcjX3C91mLIGqqOrQQKGmujYhZUBPGe6HXFBNaw9
	uJlE1SX39lm/BRJH3L8zLPXgZ46z70dOHhtO6SUkBbnyRjy/pUOAU4Wzq8tOxkJvGC832isKN3I
	yHlHpYgCCMTwM3j7ev1AEOgpMp8T2d0hehg==
X-Gm-Gg: Acq92OHsoLiODr2nvIqeNWBaEe2y7YewhA1XRAp+OVplBRCUp4vXdFpuWeoIFoc+xX6
	94BHIq5wojCeV11XC5E0l0iiW15EnB81CuUQcCAVM25A8sLl1dTv1HXPFG8euFJTd9tzq9oy4NO
	L+OxIuDpfQGwW7Pes1Ol7lfuW0L17HTB6ijfU65iazvI0bSZfiL4IUPUqpah8HeSED9fz96xCkb
	wa4jTisx3Uaey4dJeMnnAiahO2udD90ZMRIh+53BhpaSTy/nOd7Sy9jOKpWOtW5RL/ln+hd9w6U
	IOEFNoOkQCCps/x2Sgg=
X-Received: by 2002:a05:7022:239d:b0:137:fa50:a225 with SMTP id
 a92af1059eb24-1398fb52601mr263939c88.12.1781648629295; Tue, 16 Jun 2026
 15:23:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Amber <edoardomonterosso2010@gmail.com>
Date: Wed, 17 Jun 2026 00:23:37 +0200
X-Gm-Features: AVVi8CeuO2YH2Y4Uexdf6T3dqzisLUlC06iKsBHJq53lG7mtzIKaSu0ihs95m2w
Message-ID: <CALuM0_aMUsWM0xGOrda7-jizQmmzJ6+cU63FVm-epMwEeifiWA@mail.gmail.com>
Subject: Btrfs mount failure; log tree replay error and transid verify failed
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

I am experiencing a severe Btrfs filesystem failure on an NVMe
partition (/dev/nvme0n1p3) that stops my system from booting. I am
running from a Fedora 40 Live USB to try and find a way to rescue my
data.

I don't know much about filesystem internals, so I am attaching the
exact outputs of the commands I was told to run below.

Output of 'uname -r':
6.8.7-300.fc40.x86_64

Output of 'btrfs --version':
btrfs-progs v6.8

Output of 'sudo fdisk -l /dev/nvme0n1':
Disk /dev/nvme0n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
Disk model: TEAM TM8FP7001T
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: D2CC4AA6-D32A-4B69-A117-FA5431D953E2

Device Start End Sectors Size Type
/dev/nvme0n1p1 2048 1230847 1228800 600M EFI System
/dev/nvme0n1p2 1230848 3327997 2097152 1G Linux filesystem
/dev/nvme0n1p3 3328000 2000408575 1997080576 952.3G Linux filesystem

Important parts of 'smartctl -a /dev/nvme0n1':
SMART overall-health self-assessment test result: PASSED
Available Spare: 100%
Percentage Used: 1%
Unsafe Shutdowns: 80
Media and Data Integrity Errors: 0

Initial boot crash log:
[ 4.027710] BTRFS critical (device nvme0n1p3 state EAO): log replay
failed in replay_one_extent:880 for root 256, stage 3, with error -5:
failed to lookup data extent for bytenr 13497643008 disk_num_bytes
32768 inode 993755 root 256
[ 4.027727] BTRFS: error (device nvme0n1p3 state EAO) in
btrfs_recover_log_trees:7789: errno=-5 IO failure


Errors from 'btrfs check':
Important parts of the initial check output:
[2/8] checking root items
parent transid verify failed on 323993370624 wanted 15274 found 14939
[3/8] checking extents
owner ref check failed [323993370624 16384]
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
there is no free space entry for 13497565184-13500841984
[6/8] checking only csums items (without verifying data)
ERROR: errors found in csum tree

Final totals from the check:
ERROR: transid errors in file system
found 69424640000 bytes used, error(s) found
total csum bytes: 66219348
total tree bytes: 935608320
total fs tree bytes: 782991360
total extent tree bytes: 71860224


I ran 'sudo btrfs check --repair /dev/nvme0n1p3' and hit 'y' when it
asked to clear the log tree.

It said:
"Clear log tree successfully."

But right after that, it hit the same error again:
[2/8] checking root items
parent transid verify failed on 323993370624 wanted 15274 found 14939

Normal mounting still completely fails. Can anyone guide me on how to
save my system?
Please CC me on replies, as I am not subscribed to the list.

Thank you,
Amber
