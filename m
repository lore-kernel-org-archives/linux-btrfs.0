Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5667F5328AE
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 22:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788906488; cv=none; b=a5MJ3Wklzwe/m8ElHptalv3uokSoGK8dq8pe5N9yG6ktdKS4z4SczVJ8kGPQtku8KSli3gP5SQEVHRqezvhHMoeRvrRUiwz6VixIpCgZAyIDzIGK2pDCudq7ftSgD/iquewtpS1XMVXcjAwPZGHYho4HEguVzv2oenMu2+misWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788906488; c=relaxed/simple;
	bh=HLg2lbwzzOHSgGaPYCDHwz+1Rk8J0DfUcGDqN5rbGTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rT7osLKEqky9IzJVZozpIRQjIrU3xbP8FhSMsBMgHgsdevxAHO6Awj16OvLuZoXLafsOxdgB+V2OchdyLqE4u8U7swixQUjl+7ttyMnS9JcOOuEjKinIb10x/8ri1FAULK+jQrNATORJj6y3UrbANVJUUhRrBOrhtDUXYeQRzcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sX5hDkhc; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Z/QkGOpz; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sX5hDkhc";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Z/QkGOpz"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Kv8dR2563857
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2026 18:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=gFr6
	eyiExask1WnyL3Xet2TTasaMGO96hT07htdHUvk=; b=sX5hDkhcFsTxLOeTnfYT
	j0hOnzZkR4O7OLBwWeGcldsLDcMx1hXU0ORQdV6HzKeUxRaJHWNeBSS4mSsnyQv/
	JR0EuVCscHJ1b7CsS+I3O21eOrndYjSH0ujobOjva44pQqmA9rZCo5bQd++0VgV1
	k1BbSYpz3rrZPlgeY32obMyVOa4SYnBLi+M/Ql+/dmakFHUmia949tHzwrzrYyEh
	5+wy/3tBrJ0oUsfJdZYubmrErNNr1LYaVaF88SGyhnEhwBPmUM5X+KJSXR8mXU59
	V/x4YWnGkmjjlTnc0zl0FvzFyfDootCAkzjRZ39zC/PoV5MY3eOQDho8ir0TjP1s
	Sw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwhm341-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 18:28:05 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e7f98bcb9so66869856d6.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 15:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788906484; x=1789511284; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gFr6eyiExask1WnyL3Xet2TTasaMGO96hT07htdHUvk=;
        b=Z/QkGOpzFA0XOdntgpS+v/ZnJvCxFcbAQX6Z8FqKymFPx6PaWoWxGXEop27ADilR5T
         mtuHltj4zBBQ46foUcPLXr0bSkPdFv9JFLImV2j7//53K9boowbpY1J56DcsBCcUGPge
         cHlM22g8gqruT6mU63wXOFqi0lHpruJF2tUVlMuigd8ZAB0fIt9Fcb6qb/f+HKQQNOs9
         YLJtbBklPPxt0nJBCsZ+CAxmH3TltxkNoyElbAfdgoNJ8pSCxmkDKN9RY7lX8/kE92ha
         Pq0VKqKe3rggOOzK1ak4gEtVp59qpOSI5RD7ru3NhNYvsz/2G7UlY9i+K/VVjFjky1Im
         hs0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788906484; x=1789511284;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFr6eyiExask1WnyL3Xet2TTasaMGO96hT07htdHUvk=;
        b=F+89mosjoggeN0o3gJioXQyAbKdhrTQu0Y6uGnMkHtqpiLP9UZD8G+Hj8FJhLo4dp7
         +O/xHHw98TJErud7GCNg8j10M4hSVG5rUrzxVVfVI9xOGd7NG5rtxNprq1RPKO7RCbb0
         /D98Ictxq/mwLtnyrVVQaKkrZppl3UXXjrwZ78FQRJ2FiPFchaMvDNkkjDsRZwbe9z2F
         rQPvWRYgLkBJmwrLrxnqRjeKHgOvxdDyxNFJYWG3RUQttkz58pBDt20jd+rPhqHBd/TK
         ivCdHMlXabx/jR9QH4ovPh17gTaeTs/EDRDTYSwVolb8FbrTp9fr5yerPXSezSmcY5y3
         c8jw==
X-Forwarded-Encrypted: i=1; AKwUvBz/grUFTDOB0bDt5VY2GqhO6qzUs3WSZDU9UgqdGhBiXg2Y400Lb1ejpBJt0P6m8zRm2vQAZG5pXHLEpw==@vger.kernel.org
X-Gm-Message-State: AFuF++nNwTP3b5NmxYzXA5Ju6pHTnK2qUT8XSfd3E7SlLqJ45io7E6g8
	dGkodZbuv4yAdGnV3O9JnhZJoTH+Xn4iwct+n1COfTBnEP7+7mhm5bP+7E15xqk0vc5SsvkYH3c
	M1SJmKmAOKYvyzJBuIKxEQAWu5WGnJJyrHzlypN3F/tPBxZrWT+GdQZmhV1du
X-Gm-Gg: AYBFou3Fp5rwkPUVgyagmALHiED1mmwmgTU3Fz6vSfpsJo9fwM1nnSKFYbx2Ji8jnDM
	xHr0ygokSUTaGBkpeBOdK3rfBnic9DmvdUWVoAaUxjzLXqWMOZ8wfSkyYOGtNApwq0NUJMaAlW8
	VhhH3pTZ60DZH2XB1HrN2r41i4aNdFz9hIBZifpdHFFx1oL532zMjXEQKamwXtduGNuVPoLiP9s
	eiIw+7tfhX0O9sGxQ4Iv4xGVGikV2S9TI2R3XGLIOxrImNESKK+5fVCNPjIYPl3e9tPpkFr5NI2
	QVX/duN7R0ZXKKkujiTZUZGs4PMRmHCE1SoTXpQ13hSadLQDiegqR6s7wlf9bkXvxRCiIVtWEWW
	ZMh6mw/i0C2c6PAaARxMNV5un2p2k9knjPjKuexudBkriZTVspgkQ
X-Received: by 2002:a05:620a:4553:b0:939:c898:ce3f with SMTP id af79cd13be357-939c898d8a5mr433433785a.14.1788906479357;
        Tue, 08 Sep 2026 15:27:59 -0700 (PDT)
X-Received: by 2002:a05:620a:4553:b0:939:c898:ce3f with SMTP id af79cd13be357-939c898d8a5mr433428285a.14.1788906478899;
        Tue, 08 Sep 2026 15:27:58 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939b554f1d2sm442937585a.21.2026.09.08.15.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:27:58 -0700 (PDT)
Message-ID: <47b274e3-0d62-4b13-871f-8e34141da2a9@columbia.edu>
Date: Tue, 8 Sep 2026 18:27:57 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/15] btrfs: remove the free space inode ordered extent
 special cases
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
 <20260907-btrfs-remove-v1-space-cache-v1-12-5f9a5ba352a7@columbia.edu>
 <20260908154231.GE9053@twin.jikos.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260908154231.GE9053@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Zubd7d7G c=1 sm=1 tr=0 ts=6aa08bf5 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=J6ZNMGKFVfwIeeHgaGAA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: vsaucuBYvrNXYP2fCiuA-7zIIdYMfc_l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDI0NiBTYWx0ZWRfX+/pTEj8EPp39
 DgDuS9vhGAhkXKVOU6pCKCHUQGkWCs9ORQltK+GbULpF6J4jgigVkZW3rZTc9BucR7q3SMNhpzu
 1b5YOkxolsCj0rcIV2sZcbGqbelJQwzyCevxG8yRxJuIqbO27HVHqIMFiOnPGLscVbo4zMpRvQ9
 VAV/tP204/BRcHPTFnCwH5lw/HSsobEr2n7DqQ9QvThO+M+SAt6bcBH1yqvixBVJxdruXGrEHCr
 xPalroci3A3/KcfJLiPLM2IKRkXdUiEG+D8xEAV+pX8y96w23k1n7vHV51DXGaX9W2NNJafvNE2
 byNRreN1kKiIHeY5+ga+sy9fJcErnSyxUV7CldrUs5EsjdTGvq0h24s43a+vF9IYk39bqO9jvXI
 6YjY1ml2/9Z04z2S+RB5vyM6uLgZfSfkaTcZQYhskRhr591ddcjR3Yy4/2jLtgHIi1GQGifAhbo
 jL455sdrKbheH7UkMuw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDI0NiBTYWx0ZWRfX0QG3o8/Gts9L
 fOTx2SZksaXzwoUbC/XVuynGBr2zWzcfTa0VfOpyEmRF/EMX0dwqVnEpwJdXsRSC6zPxujKh0Jf
 mHGIoQtY7MDxSCI/ZzCM3/bmwY/1BC+iP8mWGL2q4IY24bvifVt3
X-Proofpoint-GUID: vsaucuBYvrNXYP2fCiuA-7zIIdYMfc_l
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 impostorscore=10 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080246

On 9/8/26 6:42 PM, David Sterba wrote:
> On Mon, Sep 07, 2026 at 09:19:27PM -0400, Tal Zussman wrote:
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -125,17 +125,14 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
>>  	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
>>  					   __TRANS_ATTACH |
>>  					   __TRANS_JOIN |
>> -					   __TRANS_JOIN_NOLOCK |
>>  					   __TRANS_JOIN_NOSTART),
>>  	[TRANS_STATE_SUPER_COMMITTED]	= (__TRANS_START |
>>  					   __TRANS_ATTACH |
>>  					   __TRANS_JOIN |
>> -					   __TRANS_JOIN_NOLOCK |
>>  					   __TRANS_JOIN_NOSTART),
>>  	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
>>  					   __TRANS_ATTACH |
>>  					   __TRANS_JOIN |
>> -					   __TRANS_JOIN_NOLOCK |
>>  					   __TRANS_JOIN_NOSTART),
>>  };
> 
> This touches the transaction engine, there was exception for the space
> cache, I'm not sure if we want to remove it completely. At least it
> would be good to separate the space cache usage and the the API in case
> we'd want to restore it some day.
> 

Sure, I can split out the transaction changes from the rest of this patch
for v2. I'll move the transaction changes to the end of the series so we
can easily drop them if necessary.
