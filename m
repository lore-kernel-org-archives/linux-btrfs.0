Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A173603DD
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 05:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784094421; cv=none; b=cRurHHQC+h/VkAKMNY07fHeCqKOrD/Ff7kcyAnCtaUbZuytOqVuaxOe7r5YDdaB8IfYisFBj296po8Smv8rl3Q/yI6m0hWw17gKaKuDijJAbfUAxojYJCZjnFVZhhUyNrpMv0NTNlwJbVfR3kdNozeCNEgQrsXbpgMrtaeMCGes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784094421; c=relaxed/simple;
	bh=du8kGNgVNIqSF1/8MzzzF8llfeiKwV8ibKupVAbtGlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=co/+r9FQOb0hBK7rmCUGWomisyWnH8npjGIH6UxJSsum9teDPwHiqEQk9vE6R98rad93Op0q3aTBFHS/O62GFzw+CHzAYCOicm+Xi4y8r+GJmgDfFuIZxeW+DZgnwlSI8IummL/lP8qh7D3mWWRXKKM9Er6s09lNpZEFCZAy4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IumRkNQR; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IumRkNQR"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso17685085ad.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 22:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784094420; x=1784699220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XdgiXm/2rERlWYwGbue3CmGXaxx/DV9PAEW/S9MqEsw=;
        b=IumRkNQRhch3F5n6W4D3vctD7Oy7aVgf+gcted6SPaS/dXH74P0pE/E7B0R8sryEs+
         NoB5cS17UaD9Bop+DESRvfWOmWISidBQTznh5AUICPx7FkFGGHoRiRPvywCHTjQgk26S
         iviyVICniOIEtN5r8PbrlttXANkIBxS9hRotSsKt6BoRIMAdSzalU6t20AKcy/Ys0Vq9
         TDZtcxg/SCGhpA2OsueI8cmRgyAM0ALNQOM4b/iaUKRMGBWTYZSN6fhNMvrKLIT22S6f
         oRFB3Dbfebqbk7bmSh1hAmerskq/I8GfQP42O7G8LtdlmtruqfEEIN4/opuaPWsxRVqB
         22Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784094420; x=1784699220;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XdgiXm/2rERlWYwGbue3CmGXaxx/DV9PAEW/S9MqEsw=;
        b=cspkZsym9w+24hl4sDn8J18th2dOJOKI63080IS0D9kskair7Wlmeigl02366AQdac
         sDgV7r7ab/3wDy8HP7qk86UbEUS9L42cHe7Y09KmzG/jkivrZN1J2POjoKvCMnrp0+7n
         OPKI3Qlqa5qRHRzF5Btx5Y6QsPKl1s5OxSrrxxULRTmY2gnFHDwA5KCEDbsZsuc769Ho
         SIJ5Dg17aTWnr1N8jdsCX3TFM68oHbCWu5sJhtBZWmt+FuIORR5nvCut22MvkzUot9FF
         viQcYv0u/bkMKQbZ5jjAEl0DcNTtyHoKImRGhH7NZRuoFLrE5PLka2HFlCJQOCDPTtBq
         WUcg==
X-Forwarded-Encrypted: i=1; AHgh+RpGFfaNF4aIakfVJCN/Gi0uVT+oARt9LREXWq3uqhs+vShJUq+yOgwJ4YUlzGw4N2cx0eIMFuJaX5TyBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQklT+Vn7eCSfLe6zQL/qd5O4wFTP5JMnrRQaDSYuPKGanyBJ
	mVaMqHOAhP/SXvQ3f8V1/Upuuv2nciiGd1lGoJB/IZ5saehpWrrheySD
X-Gm-Gg: AfdE7ckaGve/LoiFrByajvPxsCaSwKXethcEXfssZ+bJNrrJV4WGChZOloIjGZ3+mk5
	+QOeiyxWyQwiFL7sDOWDittipj5669DvGTwDm5iPnHMt77nuWqhrc7oF45Di6Az2XU1VH/Ss4e9
	NkesRzVxKuppCQ7uXOQ6ydGA+NiQgOdtbvoK+x6Leqz7/YLMzagtdkqvKKhZv3o5FeetseYvWZ0
	JWhGaMqMhk2vKe5gPDYd+m3EGP312X1ZVGY9PiSXNw6aNu79JS5PU+cS7UlNxM7SvYfy2XmPMTq
	45/qm1xycRcQR9l/fLngIr8SDe7TKYhGD+iWfTFw7KCeeKiKMLtMx6tob+oOV6/TbCk++cbe/C/
	VmvST+sn5Jd0yvkD/hPUyOB69FBqTH6NrE5Onrmb/8aL+Y9V//zoQxuO9719ZerKQqU/ux0YXGN
	Bg6dlSVFyMHHxgzNxs5ZmXESdvKBr15zl5ITg2oFQUo+KS+qB/kFz0d1/sDbbBXNg=
X-Received: by 2002:a17:902:d98b:b0:2c8:f34c:82c0 with SMTP id d9443c01a7336-2ce9e5a55c5mr156518865ad.2.1784094419535;
        Tue, 14 Jul 2026 22:46:59 -0700 (PDT)
Received: from [0.0.0.0] (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb7ddsm128255315ad.1.2026.07.14.22.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 22:46:59 -0700 (PDT)
Message-ID: <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
Date: Wed, 15 Jul 2026 13:46:56 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
 Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
Content-Language: en-US
From: Zhang Boyang <zhangboyang.id@gmail.com>
In-Reply-To: <67cff567-1070-4908-a253-a8907d237734@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2026/7/15 05:40, Qu Wenruo wrote:
>> At first power failure during transaction N, metadata trees of
>> generation N are written to disk A, but super is not committed. Nothing
>> is written to disk B.
>>
>> At second power failure during a different transaction N,
> 
> If it's a different transaction, why it will still have the same transid N?
> 

Because the power failure occurred just before writing superblock 
(transid N). The superblock on disk still has transid N-1.

After reboot, looking at superblock which transid is N-1, btrfs has no 
idea of transid N existed previously, so it uses transid N for new 
transcation.

>> nothing is
>> written to disk A, but metadata trees and super is committed to disk B.
>>
>> This creates a ambiguous generation N in two disks. Currently btrfs
>> can't detect this, and can lead to severe damages.

By the way, I came up another solution:

If generation mismatch between devices (or log-tree mismatch) is 
detected at mount time, set a dirty flag in superblock on device which 
is behind.

If dirty flag is set for a device, disable read load balancing for that 
device. So (meta)data only read from latest device(s).

If dirty flag is detected, ask user to run a scrub. The dirty flag is 
cleared after a successful scrub.


Zhang Boyang
