Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901C547DF90
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784045478; cv=none; b=Js92Z7H+3+Ba8et8lurcYO2MrJ/MObu4s9SgvGyp9y4PotUfBNYfkvsvaXwfX5m1L+gw0c+lhfuNLtr+2TARhz8Gx4/DobXcD6e/8Yv6ZmsBZaP/FgHxIqNBv2T7rpLk5IGBnPBqtOXoVZaJ3VIj7jQDArIsFqNyJ1I29Ko8PoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784045478; c=relaxed/simple;
	bh=3NiGYzJjQ067mKb5Ca+qNWWTlUvepgqvNM+Y2dzgzSI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=c+W9kTTVYyaFZlPXe1RS/7rK2QlOAP+wW3oZgCQcXLS5hhOL2ZMsKjN7GfoM35pRzLdtTk3yU8oxr6ac8RbYz5O0CAsfAeb6unV/yG9D2E8RRKQaCnyZuHrEnE43b/AKwzJQCHweHtt8eEtYVPJtVVhNWEuOhryZnfVxuy1ziPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2dSwfs3; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2dSwfs3"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8484f229529so943847b3a.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 09:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784045477; x=1784650277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xN4ElnyPBXmv4bsesjCQ8obvXtneP+HkSrF4llGdWy8=;
        b=H2dSwfs3vOx1tTPHBPKdCK78gBRtpHjYiIz/RXlhbkSxCpdSp3rWvMVigHiDuEzlCS
         RCaARkNr4cm6vHYpCtDdGTmab8GxESL3y6cY42ZPvIvZYccSb5btAw2D0mEf8dNONSQq
         cQZxtPI97V/ClYHy7LiXQYfubnduAKA/cHW6jr5UshYBt7Y81q17U1kx8ZO0fmK9ZIcI
         Ei+dDTa9SIUsMSPT8KsJFlxiwS+PHZlry+0j3W/hNWGIzVVJqjFtUZEErpxlZvsDOkJw
         rYj/Ph+I61ztUOVMt+pIBc/3AR32VDxGdLZ+GNgCJFA0Sa5eOevrllAW40wH74qSBZkU
         TGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784045477; x=1784650277;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xN4ElnyPBXmv4bsesjCQ8obvXtneP+HkSrF4llGdWy8=;
        b=alz5UueMTvlHBgZCrqBn6VCIEEGAtJOpqmFgLCg8wBNlD28z6Mbbk4z7fHVNJvf1At
         xAUzrSvg5y/EpwONfllNOlHN1/t3A1UV3p0QMI54NfM+t+RlOLP4akh49mT0I09W7jvz
         y1OsSoN16sjzJJz5fzhj15+nczg2s3RP37Nxb7Z6zfyD9C5NRF5Umbw9l+ixFkErTPNC
         I07Alk4zyLMSlSAlscXhLD2PzcmPYODHywljNGfts14aNX1JHE1kXb6AcnXwK7THbiGx
         DKyZnWn9ipYqzkuM1sCkK8Lgjqd9nrrF74qOiQuVouBmaBdhxWw5j9ulbjvaMSqtynEK
         5rMg==
X-Gm-Message-State: AOJu0Ywh5KVk9Y8TcN/5HQrbBSep3Yi1mcdoQzp01SB01Jc4jXi3OcEI
	426KRdMw3DTFiA4kTBtIeNHdINYGU5Q2bSY4DEV++5SAhQoaJeKW8G6yx6SNsQ==
X-Gm-Gg: AfdE7ckvkyUnG1adA2Ops/3cGQg9MXbS94negM/4LJfOTpFtY6qWy67CLWEOgCU5i8X
	KOWkrcEMG6YSO4MOy5SZ6JLduN1uZSRhPjgKdptdZBTxHWbwWxMunzSt2q4yuOfW3cxhcL4Y/+x
	VQJMk87z1fSS/FQkaQt2gyOIm3DRUThNubNZ/e4CuHbLVSmYRqzsFmKz7oodCpnNif+iKLKMQqW
	nnaWLTeMt4Onoe4+pdXRf5wS582vO1Fkc/gmgChGwqolqE4SQS9cLA5Cxf2a5wjV+KstM7oJW88
	1wQXRcqh0JnxpH5r8ZF4c7W0bMmA+xAzdSJ8WGysGW+YpmUKivw1ush4lsm53gAa9It7OrhpyYD
	d55bHhrbWb4zj1xj1RL5q3PfCt4SSV0Hm4BfFK1+xDWy7skX4K+2U9Sy6if9fuyl1ruM0raQ2eV
	TveenYV0cOpegjsWvsDtbgwAtTB5eUQtAVxShC6d30UM23S7NiwL9RWNOerl5ogdDaiXo6mqipX
	Gy7ADFPmlOmjRf95w==
X-Received: by 2002:a05:6a00:228f:b0:847:e2c7:59b6 with SMTP id d2e1a72fcca58-848896bebdfmr12746806b3a.11.1784045476861;
        Tue, 14 Jul 2026 09:11:16 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f26f703sm1825073b3a.17.2026.07.14.09.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 09:11:16 -0700 (PDT)
From: Zhang Boyang <zhangboyang.id@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@kernel.org>
Subject: [BUG] two raid consistency bugs
Date: Wed, 15 Jul 2026 00:10:42 +0800
Message-Id: <20260714161044.7330-1-zhangboyang.id@gmail.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello btrfs devs,

I found two raid-related bugs in btrfs. Two test cases are provided.


BUG 1. fstests: btrfs/348: test ambiguous generation handling on raid1 profile

This test simulates a ambiguous generation which can be caused by, for
example, two successive power failures. Please note this is not related
to degraded mounts or nodatacow.

This bug may affect several raid levels, take raid1 (say disk A and B)
as an example:

At first power failure during transaction N, metadata trees of
generation N are written to disk A, but super is not committed. Nothing
is written to disk B.

At second power failure during a different transaction N, nothing is
written to disk A, but metadata trees and super is committed to disk B.

This creates a ambiguous generation N in two disks. Currently btrfs
can't detect this, and can lead to severe damages. 

I'd like to discuss possible solutions:

1) Turn btrfs metadata trees into merkle trees

This is the most CoW flavor solution. With a strong checksum algorithm,
merkle tree can gurantee ambiguous is detected and fixed.  However it is
difficult to implement because metadata checksumming is done at bio time
(not at tree manipulation time), also on-disk format is changed. 

2) A write-intent bitmap

This is the traditional solution to raid consistency problem. This can
also helps resync nodatacow data. However it seems there is an anandoned
series of write-intent patches in btrfs mailing list.

3) Generation redzone

Introduce a generation redzone value to superblock, which is updated at
mount time, for example:

1st mount: generation=N redzone=N   -> next generation id is N+1
2nd mount: generation=N redzone=N+1 -> next generation id is N+2
3rd mount: generation=N redzone=N+2 -> next generation id is N+3

However it seems there can be infinte TRANS_STATE_UNBLOCKED
transactions, so it's hard to decide how may delta should we add to
redzone value to get next generation id. 

Also, this redzone value is not applicable to tree-log, so BUG 2 (see
below) can't be solved.

4) Dirty workaround

Pin metadata to a dedicated device (which can be LVM raid1) and ask user
to run single metadata profile. This is too dirty and should not used.


BUG 2. fstests: btrfs/349: test if latest tree-log is choosen at mount time on raid1 profile

This test simulate a scenario that tree-log only exists in secondary
device, and test if latest tree-log is choosen at mount time. Currently,
the tree-log in the device with lowest devid is choosen. So fsync'ed
data may loss if tree-log only exists in secondary device.

A proposed draft fix is available at:

https://lore.kernel.org/linux-btrfs/20260605102607.23786-1-zhangboyang.id@gmail.com/

However, this draft fix also suffers from the above ambiguous generation
problem.


Zhang Boyang


