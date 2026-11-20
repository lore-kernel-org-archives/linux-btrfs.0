Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795176813;
	b=HGHhQsRdCi+bAz9xIjOJNNn4PELI4IdTfTZtBPHBkD9ZMl3K87dUQSfT3aFEnTdLTiZ7
	 LpfP3BwIPtej4C1gKA56OeajdM0XD2VUmHx/ZlvLs/IZ45AvO/GZLL3HHf8Vl0iXiq+7S
	 6qKnle1G7QcEjVZ7jyG1dt+yiDlPs1ME7y/jUmyWJspA4ueiAjQsnaQ1t1fZiB8TBN+Gz
	 uDQ5WFp+qLqUbRPcrY07LGbYZ37zK82g96uGzonFO/23Dy+2Z3sEV7uTSN+OSWzmKyaOT
	 pWoHYBfTS2Df3RxiZT7CyDjw10DB+sKtPHuBg/xjg6kqQhjs6A1tVASTy+0exDTCEnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795176813;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x0vGzRPs92f89CgI3Njfue5EhkkprE6lD4JkRb+Vbmc=;
	b=NIcgrevd8bKiIBChgPqxOgRISkJzOI2rYhJKdN8n8Gf+fDl0NXM2pOiXfz+B0a3h6NkU
	 SkdYlqEXMFjeiMqEpVGXZabHQR+wCLd4OQWX+GQNm3ccsFlS9r3ldVkibHn5Ey1LLnyNX
	 GAl4bqtM7hn/HLs9/XXvi7WKxnveltJ9nlT+YxKhgPgMeEtSkLYxPAI8KQynnD+g2faMP
	 esu9li9vFrZdZh1XlhBhXFVrenGDmSf9phu/cz/EUcT5LA9Fg3B99XgwAi/aG+zYif0Pw
	 ogfZZd6P/Aa0zQ/QWnu4qu8QLDlJ+NqDSI8NOxl8s+vIofzDvmSV4RfoCGtBiA8hATw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TshYVSCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D479606A320;
	Fri, 20 Nov 2026 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TshYVSCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4C41F000C0;
	Fri, 20 Nov 2026 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176813;
	bh=x0vGzRPs92f89CgI3Njfue5EhkkprE6lD4JkRb+Vbmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TshYVSCGCcdqwCrlEsnpn5EjqKpbRkab5aX78uJpCQ1sCJbGp6a0HuKRcLhJSG/Ug
	 Mk9PuQZrUNE6U4vE/osaEEvO05lLdcPh1oq7CYIVDd6XwGlkv/HRMNdh9Khm4zulkP
	 i6YDME7SBtXuZANtf4g+EuXheunFrh0HuK1DaFrMlZof4MQqaUZfOffiQ50VK+wAtE
	 ZEVG7mQrxilN+M14zd8z7sUoAsIwUVqsP+4XXfHGLEoSaNfWMqbpRIT3HJqdTcL/LE
	 i2+7KmQPEe1gandTXttHYjKDYTSdmP6fz/kd1dXl1hJDSRxk6dRRurQYoP/EmTOnEI
	 +KOKWQ/GpbR2Q==
Date: Fri, 20 Nov 2026 13:13:27 +0100
From: Christian Brauner <brauner@kernel.org>
To: Ismael Luceno <ismael@iodev.co.uk>, linux-kernel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/8] btrfs: assemble a multi-device root filesystem
 without an initrd
Message-ID: <20261120-rentier-einfuhr-riefen-31ec13d7abf5@brauner>
References: <20261116224316.11237-10-ismael@iodev.co.uk>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116224316.11237-10-ismael@iodev.co.uk>

On Mon, Nov 16, 2026 at 11:43:16PM +0100, Ismael Luceno wrote:
> This series lets btrfs assemble such a root filesystem in the kernel:
> 
>   * mount devtmpfs on the initial root before the root filesystem, so
>     device nodes exist to open the other devices by name (init);
>   * let a filesystem tell whether it is mounting the root device and read
>     rootwait, and resolve root=UUID=/root=LABEL= values that name the
>     filesystem rather than a partition (init/VFS);

Nope, sorry. The init and VFS parts of this are not acceptable. Scanning
for devices and resolving filesystem UUIDs and labels is exactly what an
initramfs is for. That's userspace policy and it doesn't belong in the
kernel.

The kernel can already find its root without an initrd: root=PARTUUID=
and root=PARTLABEL=. If you need a multi-device root, use an initramfs.

A ->find_by_spec() method in struct file_system_type that only exists to
parse root= isn't going to happen either. And with BTRFS_ROOT_SCAN
defaulting to y and selecting DEVTMPFS, 2/8 changes early boot for
everyone who has btrfs enabled.

So I agree with Qu.
