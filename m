Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7A33B47C9;
	Wed, 25 Mar 2026 11:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436563; cv=none; b=SCOEu62o4zNAaGHK95NP+EJZwJ9Sitg23JjMgkhTwFoN8aYvWKpKNckKhdmBSUdMVTk0uO4EAULSZ86iufbHjH6ERsrToaMOBasO2B+gYhIwHtS7yzCfzONSOaEjrFkL9G7ikqD12d1bZmKuzO9DnyeCL+0YW/ZgJMvm/N4v1G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436563; c=relaxed/simple;
	bh=cuBfcZoDG+A53mX/Zw37UyS+5F6zpOonj8CXVMOqhnM=;
	h=Message-ID:Date:Mime-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Tikdsy4X6a8vo6BQoez1v4jiEuySMT+8nkcEa5Gv9UNldRAItrOgCd0R007vXUNnrktDcrg7D398YfdMICvtq1wB1NDsMtD5xoSjTTr1ZuImO84tig0gb2faZakt62cm4lORb10fJLJbh5hDoJOwPHNrIBqrHb2KWelWMQ2ab/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=r0sPFVDI; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="r0sPFVDI"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id A898F314D83;
	Wed, 25 Mar 2026 11:02:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774436550;
	bh=vQVI5UAPP+iX1xnJmWWeIUeddN+hVEWvTwtIDGYAR7k=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=r0sPFVDIYJg/p2UD4ShXdVynjRRJzhvf+U/LCm1cGr+r/BPcC7YqxmpmyzuTcFtyi
	 N82Yk/PrurdfFAUdWsx7gqUsixclLydv4milohJZ0s8B2JDYSm/uadLvsZPbr1DO7D
	 h6Iw7YqwE4xDEbyjC05JwODYgkr1TizQFg7kq1qQ=
Message-ID: <fdd79c85-177c-4a57-a989-97613f94174b@harmstone.com>
Date: Wed, 25 Mar 2026 11:02:30 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: fix stale errno check in btrfs_encoded_read/write
 helpers
To: Leo Martins <loemra.dev@gmail.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <39eac6cef5afd99734483fa0e775a3e75407552b.1774303837.git.loemra.dev@gmail.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <39eac6cef5afd99734483fa0e775a3e75407552b.1774303837.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/03/2026 7.09 pm, Leo Martins wrote:
> The atoll() error check `if (offset == 0 && errno != 0)` can falsely
> trigger because errno is not cleared before the call. Library
> initialization code (e.g. libcap calling prctl(PR_CAPBSET_READ) which
> fails with EINVAL) can leave errno set to a non-zero value. When the
> caller passes offset=0 (a valid value), atoll() returns 0 without
> modifying errno, and the stale errno causes the helper to print usage
> and exit.

Thanks Leo. From 
https://pubs.opengroup.org/onlinepubs/9699919799/functions/errno.html:

 > The following sentence is deleted from the DESCRIPTION: "The value of 
errno is 0 at program start-up, but is never set to 0 by any XSI function".

So yes, apparently you can no longer rely on errno being 0 at the 
beginning of main. TIL.

Reviewed-by: Mark Harmstone <mark@harmstone.com>

> This caused btrfs/333 to fail consistently on systems where libcap is
> linked, since every call with offset 0 would bail out.
> 
> Fix by clearing errno before the atoll() calls in both
> btrfs_encoded_read and btrfs_encoded_write helpers.
> 
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>   src/btrfs_encoded_read.c  | 1 +
>   src/btrfs_encoded_write.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/src/btrfs_encoded_read.c b/src/btrfs_encoded_read.c
> index 3ee0d8b0..c7c25b74 100644
> --- a/src/btrfs_encoded_read.c
> +++ b/src/btrfs_encoded_read.c
> @@ -178,6 +178,7 @@ int main(int argc, char *argv[])
>   
>   	filename = argv[2];
>   
> +	errno = 0;
>   	offset = atoll(argv[3]);
>   	if (offset == 0 && errno != 0) {
>   		usage();
> diff --git a/src/btrfs_encoded_write.c b/src/btrfs_encoded_write.c
> index 7e46d9fe..bc05cc3b 100644
> --- a/src/btrfs_encoded_write.c
> +++ b/src/btrfs_encoded_write.c
> @@ -179,6 +179,7 @@ int main(int argc, char *argv[])
>   
>   	filename = argv[2];
>   
> +	errno = 0;
>   	offset = atoll(argv[3]);
>   	if (offset == 0 && errno != 0) {
>   		usage();

