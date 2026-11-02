Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793584776;
	b=oGvL6j1L1VRzS0WxYMFYMNlODkBhXtrLuX+jy+i68BYk2qL/l6UVqQ49mmnvFD0c3rnQ
	 F2IZrw4RtE1IXlPkjpS/OI/nHRom63oISa4qyXr3vDZME/DdDI3juKY9gHSL04NQO/rB0
	 0ace57BURlB7CV2nj6N+aQl416ZNLwk75FrBThjiSJpKc4fYqpM3JYoMIwX32BtJOA8kW
	 s7P4OzndFFZYTZAA8g9BjfElZuivFFByUKMuszaZAnyQYQqYYWUV23ZvjEQ02hFNHJsex
	 YHPU4YlDdyboBKXdb5c1GrGOy0vRs+9A7OSHjQuW8fVaW8/n9vwCdcqUFcGX3MaXM9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793584776;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=TOa81AMcZ39FVPpdKUi4a+jsK34E7NL5Bi1fu+zvPwA=;
	b=fplBZjoxENQX7o81foU4J7lS+9zFI1ySKSW6FvG7/69tUcfMUfVQbiY9qEjp6wDrB5mh
	 17X/dVTS8B210yexPIytdtPjrPML4J6WubCXKtDOIovwkWQZyfFfFct2HNkR5YBbRNuV1
	 doI1uHcrg8idQ7SW9bny0+H+gplYBu9YwSK2xFLJUVka0fU83s2iq36yr3oRdDvV/sO50
	 Dg/2sT+02f0jXM4yiZVBEjRf/os4qc9R1fXAZ68CYhGAf396R4AsXpbnnhBl9s2uHgsN/
	 QRcCDgFhN9vuVsQwjnrrUqK9va4qN+ZGXz6Oc9coq7CAvSlmDCyol+YGcdkuGnTMndw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Mz6kD96k;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=TNNLVyBO;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1C5606A329
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 01:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D1C5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Mz6kD96k;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=TNNLVyBO
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1DShSY2915523
	for <linux-btrfs@vger.kernel.org>; Sun, 1 Nov 2026 20:59:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TOa8
	1AMcZ39FVPpdKUi4a+jsK34E7NL5Bi1fu+zvPwA=; b=Mz6kD96kVplItFSo8ra0
	2qdsM4Hk13j55ItZQHvGa91+l2LcpZpC6YSnV19GSCxGIYVbivLeQu+eSwmmdV/m
	snscUURbS+gNrPOnuJkxuAuonUERyq6VhndtrXQRj1VnhF5KSN9TIJyJ3MdULojq
	4e4qeB42BTz7FPZcCLZzdAg6g4Z50XZNvULk2re7VwZEygPY1ORu7A5IcpOk+WB+
	KXEW5sB1MF7feBUYvmO+Kltpt5OyL5TDuZEO4UpzOWJsVxGCaIq/8jFulqpD6Dkt
	4PAkKHadGxT+FGV4R8AVup96qqXZvuGFIGbOcRYU4AzVW9V5NOusxyYt3vJSmlE3
	Dg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hnwtt4qcd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 20:59:29 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f568dee56so111917485a.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 17:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793584769; x=1794189569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TOa81AMcZ39FVPpdKUi4a+jsK34E7NL5Bi1fu+zvPwA=;
        b=TNNLVyBOfQ4HYc2qWQV5Hs9a2k/mgCM+owx4CTV9+yAcIo0sMFPrECssRDjF+5Q1YW
         MFvEbJDOuYswJePR7P1VPKibo/wvi4sBpm96erRUvOl0VK95Qm5Q7A+zXpnE3Y4NLa7d
         k84ImLnqrB3PhoYPrxAgIvGu8bxPAFrwYf8VTyKIWT2u1HkQoomkoYR6o6Wm9k1gx2Xp
         139w8p/Tm4oKPa/9JuqRQ9KjJRNILTSM9ZaZEQ5ZY0/lzEoIqLLWu30xzdIQO3L50Svn
         t5312P+x8lcdGhJ/ZxZkHwq1Kp851yWBHo2vDxWuRCV09snirwLbUplZcPX6hsBWHGGw
         u9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793584769; x=1794189569;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TOa81AMcZ39FVPpdKUi4a+jsK34E7NL5Bi1fu+zvPwA=;
        b=TJaoNc9Wn8F+nuAScsC7vT1zqKxb9oN4C+kdubEgfDOvr7BEsAK3bOlh6G++d4vAsM
         qSIq+br9IiLQNmty2j62N1KN2gYArwTwVDWZE8vG5KJd5nohrE/LtLiRfE+m6vv/6BLJ
         Gl5iGYYL45lxx54El8lErDKCxP6sa9FfPfskj4QfOhiuzktAH7dqnmnKAak8MamrDMff
         oS3FpkgFotHjNVYzEMNOJnpW6ygg8wps7ppI6Y5TFsb0sqHhsVgWwaPJrZt1AVbAWaor
         gujyG6yg8yt1WVr1OyZgDXS1ATADPIVN5yt3xXaxMmfplz9D5znYr4rp4Ztz/+wousgC
         z8Tw==
X-Forwarded-Encrypted: i=1; AKwUvBw+XYzYSI/2MucxzarAmXoQgpRXdE6mu9UO93wBTzVHYinN8WkqTKEEs4UPy8N5NJON050zaSB+RIqebQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKA7HV5Me98ljX5jI9Lfyp5n7vNKFtLOFFPenjXExbt+Cp0iLUc
	UUiK1841TwiVj351lv/+VmcfmllTzwwjKsvR95/tTv9CHjwUDPkYn0fu/YqHRBj+AWMZy6gaCTv
	GOXA3ffmeLUW1FaTYvBnB69HDKK65aCk7I74ju3Qf2FZAJhp86ncA9nZXP/My
X-Gm-Gg: AYBFou3bQ4wGzQ77hmVGwLQOA1L/NMlLSwsEUmLO9LK1x9JrLOl8ziIZ+4Um4+1TQBQ
	b7L0/25D38r96F0JjtNcuDoUPB6HBeXS9PZ4xYdy2Gm7hSgOpVuFKEe+DErt+lB7nxPw8d1NBCm
	Al4b8+Ftm7teKe4pz/ZUI//KPemnrUDlfDDqCkVORzplW8cvkEMM7THKdkl1acjfiZKzdHOwO6Q
	7EMENkjw/aX29fTw1V3b2b4tzcQMtA4srv3r0gAP3AX1PhtBuLePWi3fi76WULiQuR48J1E5Diy
	QelgIZ6ecQMZg5JPavC1CPGwOUhqULN8fcVtxmluEGBlJQgL688YnpZwUId5JDsBTXrfMujbKcb
	94Ypx0wXr2iFjgXcU5nXoR+EeBBd12LCdAWKb8HBfN4N5UBJmwY4B9WYjIcoZn5fOTKryDkFlYc
	qYZ1U3ajAbmWFDTagGvj424eX6/Txi9vI4NffTmoRM4UVrrbwdvFa4m9+x6jtTWJ9FNSGqYNq+s
	/8MqVTTALb+318oajRfX+RM91rhgr7ImH2DFsastFZCFytU07mGEAq2+tSSCp8SNjO084g224ea
	/liGR5WIaTaKWz7W7mZ848ftMmSWJjuhwg==
X-Received: by 2002:a05:620a:2996:b0:93c:c405:3215 with SMTP id af79cd13be357-944216970b3mr1557091985a.44.1793584768854;
        Sun, 01 Nov 2026 17:59:28 -0800 (PST)
X-Received: by 2002:a05:620a:2996:b0:93c:c405:3215 with SMTP id af79cd13be357-944216970b3mr1557091085a.44.1793584768559;
        Sun, 01 Nov 2026 17:59:28 -0800 (PST)
Received: from [192.168.1.179] (pool-98-113-200-94.nycmny.fios.verizon.net. [98.113.200.94])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425ac6bddsm715383785a.37.2026.11.01.17.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 17:59:28 -0800 (PST)
Message-ID: <1b21a602-aeb1-4e76-9f12-87761d89de86@columbia.edu>
Date: Sun, 1 Nov 2026 20:59:27 -0500
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix bio counter and bioc leak when async
 checksumming fails
To: Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tz2294@columbia.edu, stable@vger.kernel.org
References: <20261101-btrfs-async-csum-leak-v1-1-feafe7ae61e9@columbia.edu>
 <d9990870-188d-49b5-badf-9e7ae9a273ed@gmx.com>
 <3d3cedc7-a148-40ef-ac22-9aa89d0920f6@suse.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <3d3cedc7-a148-40ef-ac22-9aa89d0920f6@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: j-XCg4yojVD0y6AoXDBAgmS91uACJeie
X-Proofpoint-ORIG-GUID: j-XCg4yojVD0y6AoXDBAgmS91uACJeie
X-Authority-Analysis: v=2.4 cv=RsRQvymK c=1 sm=1 tr=0 ts=6ae7ee81 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xAVkXJFauo6zK1gNGjfgTg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=6ma1GsHSQ2guFgE4MT8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAwNyBTYWx0ZWRfX/ERMx7QRWbta
 rw87Gw4zTipMbCATmlXsDGUXctyY9sVnmtFCw+xgdnVO1biHslunMay+SBv2gpKDN7uPfXmY7f6
 Do7xXuFZVPVBDrI/Nc6kRj3j43YndTCSjn7Eu6uB7Vvf09rjk45S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAwNyBTYWx0ZWRfX8tVJj5suZYac
 wZnHfXnarNG8V9JGMOX3rWmIVk09n0umLmrHY7kR/NE3kQ5LPriEB7c6CAWdxHYZzq1CEXsRIaU
 3o+uj8cUqzNlZ1fiU4D0IB1IDkLpie3jTUpJIvCMPfWigg9hMYFznidIZNB40HWE40xaWgd+6cq
 4onfO/N81VT7KwxrXU3Ec4h/UeZVqXp5GOL7nMCUf2xbvf/FVQ3G9P7YsUsqDqtYi20YGN7Ls47
 flFep0F4Ymi0e9IvYOGm6yVPwgDOuhxiOZPcxEydJO50gKhEvaMNCa5ASUS0fKzTBIlG6xsijiO
 9cLco78fvsysymZy+tsjusD9WGVp66w7kXft+TZw4+7t8QdB48VthpGhcohjKQJlHBuYMvCms3s
 AiEXbr6yTC6wmS6i+aA+fVWo7oDZtpw4ubFOb0QGi2E5EBZgYX6NP654lt5UVzFmVwi8MYVNjr3
 JpMH0RUSCm1QOM/Gs4w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11953
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 suspectscore=0 lowpriorityscore=10 impostorscore=10 adultscore=0
 phishscore=0 clxscore=1011 spamscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020007

On 11/1/26 3:53 PM, Qu Wenruo wrote:
> 在 2026/11/2 07:08, Qu Wenruo 写道:
>> So I'm wondering what's your setup? Are you running SHA256 algo for 
>> checksum? I can add it to the commit message during merge.


Yep, it's a sha256 filesystem on a non-EXPERIMENTAL build, with
failslab failing the checksum allocation in the worker.

> And Sashiko exposed an existing problem, even with this patch applied, 
> the error handling of btrfs_split_bio() is not going to release the bioc.

Good catch, I'll put the bioc there too and send a v2 with the sha256
setup mentioned in the commit message.

Thanks for the review!
Mani
