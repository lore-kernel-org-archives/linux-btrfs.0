Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D7B3E16AC
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 08:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779697228; cv=none; b=t9DpUaXSvyMi7+VcDCs9i1asYOp1eOibTR3XY8f1H5o6rSgqwkuMwHAionH3uDsj2qraz5ueTEES72SybSE2jcpXIhnav8zLvpDQfkO9lXroVPKp/dJWtwXJaFxQ4EMIcjNzMWGWSmGXrcHqUUNGH3YEQJ8cVkGF9ag/aqrJJpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779697228; c=relaxed/simple;
	bh=e8rEW29dCniH2gKK6PkMgFes4ymdMVTdoX5svgA4o5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=REVFcSOxW+IJoLOXwbiP0vU8yS7dZnWAvs+AS6vhBFnnhpPzDasCBehFvw4zDVingBCzpH0/jDNf1qVx2yrdDl7SvZ6rKypmcvUUU0nEZ5lGLYzNc+IYZv1+qeXWWS6J39VEtgyT6RnuSUGKnYuNuxBY7xbEQSSJbepfAXZGxi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9X0o17Z; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9X0o17Z"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c80167f5716so4017398a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 01:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779697225; x=1780302025; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rP2XwVbHYZOzOgD0rZjER3jPkSEkCdbeWs9oiQjvBWs=;
        b=A9X0o17Zr89QqXeFZ+ZRnPmMd2mdJwS5yCF7yiSkMvG81FroLZQXuGSjBdM7ah4Q7+
         HH50kzRRnTXkVj9b1mBXISGxmwNJxtnCaaA8kovV/oXbiqjKV4S0alRvDF6fbmS7BEO4
         xJPUmMkg8cmyAq+BlQYrnN9ZzD9yjvNyF4XoI7LsxnJmS1RtXYxwUBeqHJszbj007Wmz
         AWZ6t8MXHhDOKNLct4zlD0+wxXz5z1xle2G7pTGZVk0nNBR1cxCrMILtddJuf5CuwSUQ
         38C34iH2ziiDnC5uldEajKL/TJBfV3RlvP7MkmSGy+jSTzJqjDmS8AH339dS6DnKm8GE
         KWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779697225; x=1780302025;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rP2XwVbHYZOzOgD0rZjER3jPkSEkCdbeWs9oiQjvBWs=;
        b=qtrkf3o50kbnHgxkN15nGHupANLFiKMRVIE2trMA0jTcTQ1XtCqM4OoYwCJHB18aaM
         grHYsthJalaVaEMWSEUckdLvvb9UjkQDMiybrZx244iEwDt36xJwCfxDRBx8DbB6AIwn
         Nx61dGgwJXcLgI/ci993Ngp0zwnu+C+iDYpdEurYNpe+1HPswhYo3gWclYcHzM15q3F5
         Y3bjO90xpHlaOxvd08dDoipmd0vHe/R29/0/+fVs+M/gIaZ0NWc7b9EQ6SeO+B1XXVSS
         f+s/w/EOINKZtHUYUKtEvb7jwc1pfqp/0fqRZ/eQgLk34dWmZtkPuzacEBnQNIxfw2N7
         MoZw==
X-Forwarded-Encrypted: i=1; AFNElJ/ahShJ+u34HlQNWbc57AUs3Pe+m4iibFGpfOsC80RnjNsb05D28bi2HJDKYub5t9c4uMIhlMPWilQjoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc/wn1V6XmbbFefo/mzXaj7Izmdbc+7jm1lk7eLqTJwFBXUYTE
	VVhDOzlmGvto8TxApjmZ3i9LgfSTQHJxkoC9OhCjkfMmfJfFoY99df85
X-Gm-Gg: Acq92OE9cHDGn9vVoQDZSBKVqNpFbOsDWf8ey9jI8wIhKoi6W90h/LUfNHYL4k92bIH
	tu/U/x5D1COVV0O4pHkrIHnZ8HfwPryBgTg9J5C3Obpb8YhjU6H7RfZ26O7VDGxdfoMYk+emj/u
	1smQEVWYRiAakMB1txUrzly93Wmr/F1MREg3gFJ/k3s35EDyF7jScLcBb38/TN6F6glQPU3f0bK
	LGVIcCPIwSrnOPBjSh1YFSyoe4Vi5aU1paPA4ov08zgDo03R4dhNsAESVd+rAxndn4MtsdeWfXG
	We0KpT8/m17SYncZjslY1+ZXPTFqfY9YiZeaC9qB4PAt9VHXG1vIfn0Og8QYaOw2UaWexUTZA8l
	MKA6lqygttl2qKEAis+Vox8JnyoLNj7k//wigEwlvr914wOfOhEEk/TMKybRaqek1RH/lt3BpAF
	WFy3I5bMTxNOsAk7FaUAslRLaQVsg=
X-Received: by 2002:a05:6a20:3c8e:b0:3aa:55eb:a5fb with SMTP id adf61e73a8af0-3b328d15f18mr14912245637.23.1779697225436;
        Mon, 25 May 2026 01:20:25 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852056d767sm7212551a12.25.2026.05.25.01.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 01:20:25 -0700 (PDT)
Message-ID: <0f774a12-7355-45de-bf95-4c98193d4727@gmail.com>
Date: Mon, 25 May 2026 16:20:21 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] fstests: verify fanotify isolation on cloned
 filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <bfc0c92a33bf5a129dad4c3e4c76973e7a6cec74.1779367627.git.asj@kernel.org>
 <ahP2OOXmwsM87j9D@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP2OOXmwsM87j9D@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/5/26 15:11, Christoph Hellwig wrote:
>> +export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
> 
> Same comment about adding new common bits outside of test cases applies,

Got it.

> but why use both inotify and fsnotify?
> 

The SYSCALL and stuffs until fsnotify_..() are different,
so I decided to keep them both.

>> +[[ "$fsid1" == "$fsid2" ]] && \
>> +	_notrun "Require clone filesystem with unique f_fsid"
> 
> Please add a comment why this happens.  I also have to say I find
> the if syntax easier to follow then && with a line continuation.

Got it. If statements are better for readability.
Also, I'll add comments.
