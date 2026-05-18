Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B6D374731
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115444; cv=none; b=fPI/L9hcIn0uxy+ThnNB0skyqMnRwUqlpUO5+TXSRXV7//zJEYwkHgTWV+Z5wNZbhNhuoApcI9Mj05d8FnzAfa8j3TrY0XvcEvwCg3LxeXuXucQrGC3Q8qMxqyI41uxmOfejtMcyVkVcuFYDWlJswjyqHVjW0Yq34DsmQ5cAlIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115444; c=relaxed/simple;
	bh=DyV8E3gxpcSupU2HjznTUlS9YPVeCW8iPycUi9wK0EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fsSYy9/Wwu8i36TpRJwALKy2TwINER9WmYciLQgV/AwISm1dR3FoDpr3ucCslSWgF6y5D8g2pc6aBW0VY5ji4oJx25eLJXBzQYfIXUGobS1nTnF4SFtKBFA/zySqUsQQoDDZyFJsGvO06qAcfmYGSEcA/42ByciTscdX/s/sIeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4+tDHig; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4+tDHig"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82748257f5fso2132538b3a.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 07:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115441; x=1779720241; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aw3Z5TVg60gqBwRTovyIOoXICrBGxM4+/44g78bnGc4=;
        b=M4+tDHigKh0ivz8gpaqr/o19kEk9bNx2U3Mj4EY08txi1IAUE6OR+8wwYW03j3GRTy
         h0RB1/Vq6EW4E+FQcM4zykvp5Fjt6u5kM7aigRyTme6flDmDDD98GjYhW1S0Cz9ki2dI
         pokBK9vGiah9n7hQM7L6drNHDw+tHDmbJyrX/HSQe9df80Hw3vfX8OdiNpxi1AGACbcM
         PR3jVsBI1IRPoJfVyaM6jwyDDVs3VqsmX6ktFeZLtjt2JekQlRNxl31pzq48IfidX0fJ
         iWogToX+yW3IOalChrMvvafe+OHhayufbWju0muC89ze2IkYf25dw7VtgXxcEs5H3303
         Al+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115441; x=1779720241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aw3Z5TVg60gqBwRTovyIOoXICrBGxM4+/44g78bnGc4=;
        b=OXgWEpHz6xPfpkzI7UmQRXgFpPafWVyc9Nwxe8eFoCDljvyp7BJrljOyrYFy5qEVk6
         UgiHommWdRYHd+bsxKJqVT+k/mGTtboWNfPY2BxrhMy/TMNcq1lsZsW6OrDcFVjSbZXW
         wGl+FUyF+4N7v1YVzu/eFktPsgW5D+FUhFlwEdvoLcaP0KtAeCHo5inPNtND9qq8giXj
         xjmUCFKZMjaeSUa6wrU5N0YeCeOjSNvtyk8PewYfzpS4UXqL4YQwBDjL3SqISruQkBrT
         4UkmWXNgaa1/RJm+ivpzLwAdla0f5irRwPya0v7xS/JuKjyGHUGusFDaP7oEb2PRnU0f
         srhQ==
X-Forwarded-Encrypted: i=1; AFNElJ8CPWCOOUxjPHNgRMj6KtZMHm8O7Opg4ux7OPfiyiZ3hziADbamLLZVEE1lg/us3nnOPLhlVd1KvxIM/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjgAY6Icr+ns1vhDW96GF9WwuOoStiVviCHsBV2AWKqJXhMyve
	yz3f+6pFmbqb4BluL3yjYZOlRVKh7JryyC9zpoQpH/CPeUIKYs/WPYDK
X-Gm-Gg: Acq92OG2v9qfIXn8peT/vhed9IvxGZd5BI8yflCX+lTq73OfAb3/cs3SF4yaO3GoiVR
	0YEGQ1AQBk/dRLEgNrQZgAp2KnwyB2zohcWLJx9PvclTNsnClvQyOS+3Sc3bJaM8ADxFR6J4Ojg
	81ZAZgBLPEBiv5XNHpmA7tDY8OtoN8S45Owiu96Qdv8OIEIEK/58mmu+NmOegKEUKKzYoB6KObP
	0Ob7/Yz9MU9jR/ZGHrzphcZiAjfjEsbmytdHolObnVuy1Wztggh9Ej5o8dqvMFhyEGCjR1FTcXf
	FGC2OiYVjcARVF4ao98yMeDso0dd69hEVq6HThApqqWIDQy0QRAZpfwMWthWu2zPxgziVPWgkL0
	dOb0iiFdNFke26zIxQEYPoYoSNHfZb82y5VdhG00aKJ7uwPoKNg+rRPE47hPHix3pMkY0p0/cf3
	awEV7qmaSPGFrBlnA7BspyoJ7DRs0=
X-Received: by 2002:a05:6a00:a227:b0:82c:9c90:6ea0 with SMTP id d2e1a72fcca58-83f33ad8782mr12373366b3a.3.1779115440605;
        Mon, 18 May 2026 07:44:00 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm13165150b3a.33.2026.05.18.07.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:44:00 -0700 (PDT)
Message-ID: <aa4f29f5-b683-4d07-bc5f-fa5520ba2302@gmail.com>
Date: Mon, 18 May 2026 22:43:56 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] fstests: verify fanotify isolation on cloned
 filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
References: <cover.1777357320.git.asj@kernel.org>
 <5857d9f33de7f0ea8ddd12c36334c6463c0bfe0f.1777357321.git.asj@kernel.org>
 <agK83s6NBxpbDREJ@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK83s6NBxpbDREJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/26 13:38, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 02:42:54PM +0800, Anand Jain wrote:
>> Verify that fanotify events are correctly routed to the appropriate
>> watcher when cloned filesystems are mounted.
>> Helps verify kernel's event notification distinguishes between devices
>> sharing the same FSID/UUID.
> 
> Do these tests pass with all major file systems?  Or does this reproduce
> the previous btrfs issues in this area?


Yes. The major FSs (BTRFS, EXT4, XFS, and F2FS) all pass, except
EXT4 does not run `generic/801` because statfs `f_fsid` is not
unique when the cloned FS is mounted. Also, BTRFS requires the
kernel patch mentioned in test cases `generic/802` and `generic/804`.

`generic/801` fails in an SELinux environment; this can be
fixed with the following changes in `generic/801` I'll add
this change in v5.

-------
diff --git a/tests/generic/801 b/tests/generic/801
index e1282f4e3d71..384e82120d4e 100644
--- a/tests/generic/801
+++ b/tests/generic/801
@@ -23,6 +23,10 @@ _cleanup()
        umount $mnt1 $mnt2 2>/dev/null
        _loop_image_destroy "${devs[@]}" 2> /dev/null
        rm -r -f $tmp.*
+
+       if [ -n "$old_selinux_state" ]; then
+               setenforce "$old_selinux_state"
+       fi
 }

 monitor_fanotify()
@@ -49,6 +53,14 @@ mnt2=$TEST_DIR/$seq/mnt2
 mkdir -p $mnt1
 mkdir -p $mnt2

+# Setting SELINUX_MOUNT_OPTIONS to null still fails fanotify with
+# permission failure, so set SELinux to permissive if it is enforcing.
+if command -v getenforce &>/dev/null && [ "$(getenforce)" = "Enforcing"
]; then
+       old_selinux_state="Enforcing"
+       setenforce Permissive
+else
+       old_selinux_state=""
+fi
 _mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]}
$mnt1 || \
                                                _fail "Failed to mount dev1"
 _mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]}
$mnt2 || \
(END)
-------

