Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18802379C2F
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 06:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863308; cv=none; b=GojtKrFsNWUOW1noolklCCtESKyxS9Fxv1khC0El5+bSiYxxsZpF2/eONnkBzdRhLbWTslE7yCQBDuAfk/RhYz5hIXEcayt8HiJnV2Jkb66vxWvhJeRI7vQ0SV/fEYz24DzD1ZQn7PHq0W8eHWtI/5QeV1zHABISHoAswDJaLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863308; c=relaxed/simple;
	bh=We6YWGS7Vshkh2dzgEtNCuoy5j1D2OYhS0q5NpjAujc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cP8n2Eme9tjx6hned+tTHPIMcd+eWq8niJx8fU6JuVNE1bOYK0WDFbVs8byArpgKCnOBARi+IngMC8oscV1vDNH5FuMjvYWAtjvmYphgT8dKwaSeu1woV1fBX6OoskhWt0m7wavGSNmJl8MfUO9h/sZwHJbPe+cGc5J4psCh8Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mzm0qycJ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mzm0qycJ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c85067c9ccdso2725803a12.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 23:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779863302; x=1780468102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1B3JgvbLHdgt03H+AXy7jnDMjCMjXn58V4DlsX2a7Ms=;
        b=Mzm0qycJl9CHfMgSlgQHQXYW881o+Qo0mDuO/aijZlgINppzzS9lnG4zJt4PRBTle0
         eH9EuBT2jtkIZK9X7ti/tvfu+z2rRuchsYTpo+3Dtn/VPdbgesbO4DdNowZHOgwqaJTW
         Jb1NFyxxn5N9nh4W+tdeYwHJ7zZ7juK6k1PogR9USDnqwBqytW4VBO4ewYZqBNiQtzld
         mTdnOxus8ZwSs2kLjiM583C35EOiSr7Onfo6Y+kihiGmZC7xQ1aUZb9acGTt98OSAqQn
         mH9uszKLe/7XPwHmVTKKnRDMenEsy+6McShUeTkMopbRVrb2i49jtDDwwFcCj1EjMvpF
         6xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779863302; x=1780468102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1B3JgvbLHdgt03H+AXy7jnDMjCMjXn58V4DlsX2a7Ms=;
        b=PTQEwVf066ppOW+1nDEC8j3EtV6R5PNNndFxZd4bPSpmTzgB7efJXk7OoxV5bf23K2
         bsoW+eoGbmRsYC+MNJo7Q2c/lmJHWChlZqM0En22gaoVM6DN+WNIA8ctc8Y1aS/fT/wl
         qlJb7n8T+ezqgZOx91ZUAD68vswPZ3COw/1QvnwNhPDwtzfnf7vc1YPxBvqBh75Z0t92
         Dm+RUyNniyceVy0kdmA++PdD3Ec4E5PopP3Ue6ZylpEC/DX7i3RoTamTgr1E8T25PvHu
         Y7yxLG6/KPTt0+6+Uu4EcF6ma9/igCQrESexei6MhlOzgUiHR+VuOHmCjko3BZNliXvZ
         pT7A==
X-Forwarded-Encrypted: i=1; AFNElJ//4MYwK5Y2pdgnfHWsJoENi/9nYuPqZVTqJqbceKWBU07jjjXRlu01QquiF/bF5+3mbfMvcvzf8hLCKA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3tJUHHMG4fdt2+6uWhbePBsy10CBBZqeqITeQFkUbAyvMpIqY
	r49zuT9kBxEanAgwl5WvT/Kftu693P/LrN5hvLCt6tyDPhnPycm5kWp9
X-Gm-Gg: Acq92OF7TJsHufIZcYbrGpTW8przISNajJgSFu6BgzHDul4vr95QSLqWGlWtnBBT1+b
	6ukwM6x1yGTvT003eGTf+eh5numK/fVNoq05JV/XjfuViUEy5GX1J69JOu3aS6mfOVhX0Ughkyb
	dby6I8pJ5WgjKWuC2ddb7iI8TTKQC1w4Dnf7qJ7kMO0DRp1OgVjPGyC6Uq4Cl7p06yn+dXq4lWf
	XRyfMUlCNh4BO2MlawWWLJ/j1mlrd6wtBR67GWMvBRoiqX7x1pzrEy5/S+bGOb7QF/+ECqdEED1
	EYPFDi9Xm4REWSkoJRXvusvFjvBxkYPYRNQqzaN6xiGCD16ZWJK2Hh0cEqlxLRCJAzjeJVLxKBm
	JBs9DsJGi35uFs8hAaEtgPKDvoB0hTS+iPaLbVTbgJFIv9govPTGGqfzxKyQV0yliWrJkQzsXfL
	UVkt9+s3j85EGzOrym+Qu2Z+UM9CejJQ23DjbmxKNsET5DlF3O
X-Received: by 2002:a05:6a00:3c94:b0:82a:5d55:5807 with SMTP id d2e1a72fcca58-8415f580e4dmr21715172b3a.6.1779863301649;
        Tue, 26 May 2026 23:28:21 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d7301bb3sm1215872b3a.54.2026.05.26.23.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 23:28:21 -0700 (PDT)
Message-ID: <e3dedd67-35d8-4088-8239-8ff145e70b8e@gmail.com>
Date: Wed, 27 May 2026 14:28:18 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
 <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
 <ahU9hpwrXyZChw9X@infradead.org>
 <e8d0caf9-df8b-415e-9f89-bc71e73a0e32@gmail.com>
 <ahaOPOQYaE1wrbA6@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahaOPOQYaE1wrbA6@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/5/26 14:25, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 11:19:30PM +0800, Anand Jain wrote:
>>> fanotity and inotify use exactly the same backends, so I'm not sure
>>> why testing both matters. 
>>
>> I noticed that back then I decided to keep both.
>> Since fsnotifywait -F is only supported from kernel 5.1x.
>> inotifywait serves the legacy LTS kernels where required.
> 
> < 5.1x is pretty old these days, I would not add test just for that.
> 
>>> Not that I care very strongly, I'm just a
>>> bit confused.
>>
>> I am happy dropping inotifywait if unnecessary and confusing.
> 
> Not a major issue, but it felt weird.
> 

Okay, dropping the inotifywait test case in the reroll.

Thanks.
