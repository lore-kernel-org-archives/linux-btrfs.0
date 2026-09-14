Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B6F38398E
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 18:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410179; cv=none; b=ShwtREAsiiO57fypaw6j6ZouP/uuN9x93hZcNvDJtK7184lbBepTh4f0MwCZsHZS6uFDPqqrAI+NsbhYJ0X8Zl2e9El/UEVgYyXe36rIM3q5lI+DZgWzeeOjtj0MQlP9HK1CpPply86sMU9Ejf2ufC51n2qLPWX5y7l3f4NnFIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410179; c=relaxed/simple;
	bh=KEmevH8nMU7yLOfWUb2ep0Z6374Cf5wjtSyh0P9vM8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=klK3rQRm9extiFsr4I/420m4Fj9tIpsSTft+z5I60k7T0JjZBqndpxOITOdbJzJT7Do+gRI5DOe2jfcc1U+b92wzvra2XneoXy1ce6TJ2pZO8/ZJeXcc0zrQWp0cJ+YiigJi09hytXdPFscWZa5srm1zkRF6Znp26hDxXct997U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=srPprFCC; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=mpVh51o5; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="srPprFCC";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="mpVh51o5"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EHnDoE3363401
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 14:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zuYy
	Jr1GFO10T7CY8FBOS83XNRwsdPPeGaoU13XZrf0=; b=srPprFCCmevHS5cteJS4
	fKr5JuU5CgUDFdzpSa0Klw6JBxa+YCK2aUGscda1ACRC4r53bBS3OrWG0A9Z6uEa
	i89+SeTmab0HDm49h6ZPwopxE7SklTWAIZmNxz8WbeJhuEFyhdYPC6SBMz0eXwaQ
	dL0F72dkbfGtUhy3WH5zrzDZpKCy38QoBwwFk3in9iBymi6vRGWwtZSVvbUvwYHh
	k3WtN7t5feGPj2eiUBV0mMFYYtf/ijGwf/oC0o2OvC41CWKKfVpHualQZNLpsNn9
	7kAHFpN7hLcDzL3wKqUQ3dOKE8r0x0z+fonDId4WrKGM4v9USMrgN+UyQL54Q9Vm
	fg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gpk8w2984-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 14:22:55 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939665a1ae6so914782985a.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 11:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789410174; x=1790014974; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuYyJr1GFO10T7CY8FBOS83XNRwsdPPeGaoU13XZrf0=;
        b=mpVh51o5CI/RfmXSYuGX+EBvDS8YStMqG7K4/sWIUkqWZnA2SU5j6pMED3bkoPU1CC
         TGnmyElxQykqMDWlkQLW7crAnEmDVfGqLkfc2qZqEpKgvBPveKKUjcr7iphdFXzTp4Ze
         rvHTBIk6J1JRI5uOv4BLt3Xz1qtkUTbsNJrve95Ww1a4txydxZNvgVRu7A+G5PsGgup7
         CRYtiEPNpMIB8osQjXf14xu1BhKk4qyRtFRz5LQwUVg7dmIaD9ZVbUN/K3qP688gslLG
         oVzfeQa3ApvZIxc/+3tFWukjnLDl0oinNpZIKYY4Z1AwhF91/kwxLw1FoT1xTuQHe98j
         dBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789410174; x=1790014974;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zuYyJr1GFO10T7CY8FBOS83XNRwsdPPeGaoU13XZrf0=;
        b=VeWlWPyiSw/cw+bWli3ePNY/f7QA+o8lTRp0lHRHcyl1AWgrir9HRc+rnQtt/iRfR7
         SW9zEZM+ZblMz2XEx2ERG2qRaG08/2ot77tgXtKpeiuC2poKX7tgTbbaSQK9yQae8PbG
         3uJIyiU+wE+nifHXZQRwutfa6eZCfzJZy9PfkkKXtudrP9I2kfC9kzBHlrLW8xakTeEj
         CHq+S06UAcsF/kuCjx71QONZVa0ulDxOWYVBTPiy3wqtZbOF0KHIUL6IPz1hRTJAXcpO
         fi+/1NtnuhaO+5eDraA/AJ1T3alFgfBVzyDLUquL6Qub7uYOtKnTqPKBZBPJkHrqn3Gx
         ChXA==
X-Gm-Message-State: AFuF++l+mWwn3OfvSpdNKFaLm8sbMhgU60pJDFhtlqJ/Wemf5+r/kByG
	VWtiTwqDVXljccMAoSCzo3lu6m1m5oXgkcQSVUxRwSB0oMPBPsrtnk0EHPxofu4sQO14Q8Jv8Ks
	SJG66S9UI4mLqsbLMeF9TTSGmbjQ6C0Mh/qa0LUnEumM2YgZtdih6eBXwgwEj1i9RJ+o0ThM=
X-Gm-Gg: AYBFou3Vs2idlB8hlPeQntYdZ/GUcmk1Rm6+UdXiRv8H2lX6TNFcOduvcFFezZpaQgi
	AiXmyYY/XM3VQ6mAaI/NqL5RhkdUPxXtHPrF7yZjAJGqrLUJLu2TrasF0uNWvfvbNq7pPM6VKuL
	+MrikhNSQ6H7GRnzkN+jYwkEgm8ixx6f+RTK9Pt08KgDsFkoGXsW5VluKrXz6mF9I1JmgU0/ro3
	i7OnhcBfdxnkjefW4sGMkWlElI8gEoA970ulJ6TpiCL4NSrmHlB3v9hn9XUh/SwY/nOTkyT+YEP
	sBLZBLI1Uv6Nt/ENekYU8YBLt//KrWhpXJq+yQuNmTBpDLkQEybCwf1L1UZgUDYznDA+OHxRVQJ
	vGv9VmVJU1DiCtoMDQV7GdpNklqsjhks2eQLvW1XJzrjM40cROAnj
X-Received: by 2002:a05:620a:6413:b0:939:6de8:43db with SMTP id af79cd13be357-93a29bf06e5mr531432085a.47.1789410174534;
        Mon, 14 Sep 2026 11:22:54 -0700 (PDT)
X-Received: by 2002:a05:620a:6413:b0:939:6de8:43db with SMTP id af79cd13be357-93a29bf06e5mr531427485a.47.1789410173922;
        Mon, 14 Sep 2026 11:22:53 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-176-209.net.columbia.edu. [128.59.176.209])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80d453esm1063239585a.38.2026.09.14.11.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:22:53 -0700 (PDT)
Message-ID: <a2bb8663-69b1-4701-943a-4311c1cdb062@columbia.edu>
Date: Mon, 14 Sep 2026 14:22:53 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [sashiko-bot@kernel.org: Re: [PATCH v2 02/16] btrfs: remove the
 v1 space cache writeout from the transaction commit]
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <20260914130436.GG54722@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260914130436.GG54722@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDI2MSBTYWx0ZWRfX//EZOdPK//ON
 iSeG4O2PC03zZEEWLPTT4c++7jnqvIss2wyJROPYTOJ1bzHnh692xO8KDaO6UrN5yEEz5yRLXY4
 Rwr/CrTACPdfxGbNwNOP9ZVxpvhBizfFilekEahHd0rKZU7LzBUzOnNCr+ZXDcOclGOFG/5rV6H
 DjZx69j+7oaObz8q9WVLgJmjklTeyqJfm+fUfNYngrSZmXDWYdhrZVfFXgCOyGiF6tLeuJ/l4qQ
 C60Oet6hFWEJUBx4tnR0qNyKBlS9W6vCqHAlHYqSIvMUbCLf2Vq4FRpDHf5Xd8jNW/NRmERVUUu
 45iIw6dM1/vvXn8wVKAJtO5xlFz5goYmxZ43e5QfsTijzFIKw1hSctaVEDEgs4eQQgK3AvK7u0/
 AhhXlxgvIdghkDza0J6/a5BRnZOUVL5PyKrxtLSHhtMwcsb7V6dLfAA/7/djq8TEJg4en6PeBSL
 ol//Uej7YkSl2t5R9bA==
X-Authority-Analysis: v=2.4 cv=Jo5kP84C c=1 sm=1 tr=0 ts=6aa83b7f cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=oIAeTKaVgyuUqLyFcT06hQ==:17 a=VwQbUJbxAAAA:8
 a=IkcTkHD0fZMA:10 a=ifjkSCkOXjwA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10
 a=A0y_DWxS2BwA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=azVShVRs0zEubeQ0wG0L:22 a=c92rfblmAAAA:8 a=5revhUvYAbv5BDVg9KUA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDI2MSBTYWx0ZWRfX1gUreBbRz8A9
 aJOfjecw/SJMjjP5kCDE2ROwMRLp9vd59cO6bEEzRxvlRjQz4zVn6MnUffIdXjj3VhvylWphpY+
 CAmXxAaII/7vvWVS9K6T7fjRra2hYVfNxCjVIeH6F+x0bE5wluTi
X-Proofpoint-ORIG-GUID: EmzGuWWvrABKzzeQ8DrCq_j4Ru41w3Lv
X-Proofpoint-GUID: EmzGuWWvrABKzzeQ8DrCq_j4Ru41w3Lv
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11905
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 adultscore=0 bulkscore=10 suspectscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140261

On 9/14/26 9:04 AM, David Sterba wrote:
> Previous verions o the space cache removal had no sashiko comments but
> I've seen some reorganization of the patch review flow in their git so
> it's possible that the problem reported here could have been there.
> 
> The review comment sounds serious by my quick look, regarding a mutex
> and block group management, all after the v1 removal.
> 

Yeah, these look legit. So it seems that cache_write_mutex was also
doing various block group synchronization. I think what I'll do is
leave the locking as-is in patches 2 and 4, and then add a patch after
the write path removal to rename it to dirty_bgs_mutex, along with
updating the comments.

> Link: https://sashiko.dev/#/patchset/20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu?part=2
> 
