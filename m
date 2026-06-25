Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D034274FD1;
	Thu, 25 Jun 2026 22:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782426978; cv=none; b=HWS1J5n+b07Xi93cyQLqTtui3TWOLHe0/zhQBJDGzMwrJHzAvgudHKF2Wi5s/Ge/Ey+jxF8Wk2wYrgrUq3vJ6IpVSknC0dkh1AOY6O74TuCJ2BolNU+GXwCrrAVoGRzx4LIOqf7RG5MHBqut6VOffClsDcVIJnxqEIJxPGQQtsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782426978; c=relaxed/simple;
	bh=WhhmgIw66TK+WBhkMsZlbIksShGYf+LH7SgNLe4pFHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvAi0fWB51DxzdEFX2eMpmtPTFY/TyYPsFfANVArFRl2+4Ivu+6tk5WzfjdOg6jSHbiM7Qu/PKXiBpok06A0c3G+dUOAIYFVFyOFCHuhhv8LxxtaoVxoNe07PCN6b6j83VjKpckA1YFkqxVCPXZEVRbPuyoLSqEdizAFpegOouw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4LiEv2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4LiEv2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038F11F000E9;
	Thu, 25 Jun 2026 22:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782426977;
	bh=WhhmgIw66TK+WBhkMsZlbIksShGYf+LH7SgNLe4pFHY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H4LiEv2Xt9MBmEfBWW2nm2/XkEY1aKQg+GQUq9+5qNJXFjToi4upO0UwQ9yCSJSM6
	 Dbo5gK/lOR+Au6N798MHiblHbqcT/aU+L2EvYj0h6ZEDvcvFFL9qXCoR8zHnzWCsYe
	 KJ/vE+niob4kQ7QmpjJZ1Djmlh59TPL/oxR4TBiZf7KkUg+F3z7N41O1HnEsZCv5jd
	 woWBovIMhJlK8sV6R1lMF52RgFxX9Sys3NouYKOZtA2mHA/sxNA+w9W9b2sGNr5n6e
	 I/H5w6VrK4iYtHvJ1CWAbbMuHjCquNLnWYp8MFCdMlytOoP8ogF/Ma7aHewKvZ9WSk
	 X+QvPdmzmPoww==
Message-ID: <a17bf9be-b32f-4d37-b6f9-fb8c6d77cc1d@kernel.org>
Date: Fri, 26 Jun 2026 06:36:14 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: skip tests that fail when autodefrag is enabled
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <f0dedcfbe5d78d950325b293cfbb9d4fbab49a55.1782406920.git.fdmanana@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <f0dedcfbe5d78d950325b293cfbb9d4fbab49a55.1782406920.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


LGTM

Reviewed-by: Anand Jain <asj@kernel.org>



