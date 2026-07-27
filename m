Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D1368D42;
	Mon, 27 Jul 2026 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785139902; cv=none; b=PVnGVvzHZBdl6ttN9uu2XS/0/b1uXEmN1Thmn+jciEzqiqbxUgKnsVYMOuJHiKvz8i3h7RJjVQyPrUoQtkQeQvVLk4locwSxgCfY8RIADa4IN4XziYzzAty4exbyC4WIJQrweXD8KB5PltYtShd3nXJe6JdcFaB79x60+LmuO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785139902; c=relaxed/simple;
	bh=SnNAuNycz5x7e3dlleiHX2E2Wv0eo8QEj7/xy9bv5A4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h966oHRTsqz5d8pY9nL9fpQ+NmexQrOVTodOm3P+8I7NxcNgdLFY7bd2Co5hHbiCbiXqhVfwWgXVkcFrIColgmMSqU4D+lBAPt8DtrryMiVzZkC1jaUtBQHb0PFoLJ4QvoOX+gGJbJOj6Qmm+1hZJEAp8fz4yXPGlAW8K7SSHKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MfZt1x//; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MfZt1x//"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R7m8vu1638939;
	Mon, 27 Jul 2026 08:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3bvZWs
	SBZZi2WnC9Vyfq+J4KpSotF5UFdrCqbN230VU=; b=MfZt1x//TP1vANPc7ySDc5
	6WRZLzITWPhltmy6KDxyE0cKuKciVjG3fNXL3B3bLtAacGfJMU4UsQdh2Wq7zw7k
	lT+gbSLMtxVeEbePUJK6lbuofxp/jviQYpNR3OPO0jjUNiNga4MAJe0Ud7Ji8P9U
	y+pxmVhrnWGOnrN5aAoRJGcTPPK0lrgNXuQGmLCMaEliwvPUIUoDyMJLZBwChKrA
	qM9HCXgc9aZyR1bAzDXQPJU+Nni97ehEzIEEmi5DOi1VwBkF8GwkvKpo9Ud4uNRQ
	YtiVJgjifvyYv5fbjiAGiF5ey3Mko4/hhdoUIDWn+cRja9Gz6Gx0K4iRwKBF7Uqg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwcpjuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 08:11:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66R8BFHP005637;
	Mon, 27 Jul 2026 08:11:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fjvg3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 08:11:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66R8BLd527788010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 08:11:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE852201E2;
	Mon, 27 Jul 2026 08:11:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E04B201E1;
	Mon, 27 Jul 2026 08:11:20 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jul 2026 08:11:20 +0000 (GMT)
Message-ID: <4f7b99e5-62b6-48ac-a141-24f25af125c1@linux.ibm.com>
Date: Mon, 27 Jul 2026 10:11:20 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Boris Burkov <boris@bur.io>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
 <amICQYTK9Xu4KLtH@casper.infradead.org>
 <d948c88b-dec5-4e29-b30a-3ea368997ceb@gmx.com>
 <20260725062614.GA2792359@zen.localdomain>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260725062614.GA2792359@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: AlLRKo7elEF5sqU-sDOskeQ0vInREgy1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA3NyBTYWx0ZWRfXxAIMAqqxzUCL
 gG9H0fw+IsRKa9r2UqdPioQMj551U7gpC5RW/9slMrOBWyS+i7Z3xQ8fGiJ16iwt2d9bkjmySQX
 9JdiDf7+xRsrgMe4hwBO1d7IyyOrBVs=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a6712ac cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=bahnriwoLXFS9mbAnGMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA3NyBTYWx0ZWRfX/HpPyWiH2srM
 wqien8I0GgjXlBEaAgyXkO7a3ZBIEbv7fNeMX6I8lSa48ximj9qPn/LWlEeqGjizY1yLeBKcxZp
 BDAp7JvmNEGX7ZpkR/nKI4iaGfME0hfwpS4e3KoVqjVjRJP6PeG1VKHJG0z2YZvfOSn1OcZa15H
 Er5VWv4mjJUxO47SGrS9oysdD4/lObMGoIJEdLLTHM0OLzY+jnpn0LBMfdbxF/F4RXDUwZ074nH
 18f2znk/62OumAQqJPi61y2w5p6LE4uNhXes+RhdeSUz7kNGFuY2y4mRG+XUdtiwvHREm3u9Q1K
 txNLO58nFgCKzxnWyMxi6iwNSu6z8/tfd5shrn7NvGOQdz6UuFzQjnlyR8M49ygWNfWLzFiC0u9
 H9WF3dXNkukD8uhDxQhDf8eBCODjpEAqre7Q7UIe9Jx6D9O6fX11mRwJzh0FvBSX6eShuk/rm3N
 3QUHsaUnxvil7o3zyFQ==
X-Proofpoint-GUID: hyf8waAb68BtR7PhhX7GqTwuJjhi11Ht
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_02,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270077

Am 25.07.26 um 08:26 schrieb Boris Burkov:
> On Fri, Jul 24, 2026 at 08:10:36AM +0930, Qu Wenruo wrote:
>>
>>
>> 在 2026/7/23 21:30, Matthew Wilcox 写道:
>>> On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
>>>>
>>>>
>>>> 在 2026/7/22 22:27, Matthew Wilcox 写道:
>>>>> On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
>>>>>>     *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
>>>>>>     *      Whenever a full clean cycle (clear_page_dirty_for_io(),
>>>>>>     *      writeback, bits cleared) completes inside thread A's
>>>>>>     *      submission->completion window, the completion-time
>>>>>>     *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
>>>>>>     *      sets only the folio flag and the xarray tag - no btrfs subpage
>>>>>>     *      dirty bit, no delalloc reservation.  See the 20-year-old comment
>>>>>>     *      above bio_set_pages_dirty() in block/bio.c describing exactly
>>>>>>     *      this ("other code (eg, flusher threads) could clean the pages").
>>>>>
>>>>> There's your problem.  filemap_dirty_folio() documents that btrfs is
>>>>> doing it wrongly:
>>>>>
>>>>>     * Filesystems which do not use buffer heads should call this function
>>>>>     * from their dirty_folio address space operation.  It ignores the
>>>>>     * contents of folio_get_private(), so if the filesystem marks individual
>>>>>     * blocks as dirty, the filesystem should handle that itself.
>>>>>
>>>>> fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,
>>>>>
>>>>> so btrfs should have its own btrfs_dirty_folio() which does whatever
>>>>> metadata updates it needs to and then call filemap_dirty_folio() to
>>>>> take care of the page cache business.  See iomap_dirty_folio() as
>>>>> an example, but many other filesystems also do this.
>>>>
>>>> Thanks a lot for the advice.
>>>>
>>>> However it looks like the sub-folio dirty block tracking is a little
>>>> different between iomap and btrfs.
>>>
>>> My point is not that "you should do it the exact same way as iomap".
>>> Rather "the dirty_folio op is the entry point to tell the filesystem
>>> that a folio is being dirtied".
>> And since dirty_folio() is not allowed to sleep, we should introduce some
>> extra mechanism, e.g. page private 2/checked, to notify the fs that the
>> folio is marked dirty without proper preparation.
>>
>> Then during writeback, detect such folio and do needed preparation for it
>> since at writeback we're allowed to sleep.
>>
>> That sounds feasible, but I haven't seen anyone doing that (including the
>> older btrfs cow fixup).
>>
>> Will explore that path. Thanks a lot again for the dirty_folio() help.
>>
>> Thanks,
>> Qu
> 
> Here is my proposal for a candidate fix. It passes the reproducer in
> this thread as well as several more intense reproducers (alluded to but
> not yet included)
> 
> https://lore.kernel.org/linux-btrfs/6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io/T/#u
I am willing to give it a try, but that does not seem to apply on 7.2-rc4
