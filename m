Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED63C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 14:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704AB217F9
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 14:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfBFOgr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 09:36:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:50716 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726914AbfBFOgr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Feb 2019 09:36:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECCE0B083;
        Wed,  6 Feb 2019 14:36:44 +0000 (UTC)
Subject: Re: [PATCH 0/7] eb reference count cleanups
To:     Alex Lyakas <alex@zadara.com>, David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, robbieko@synology.com
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
 <20181106143024.GC24115@twin.jikos.cz>
 <CAOcd+r3CzY2w94Y--9Nb+Fawv_JGFLnK3AgZdYWjNOsKth_aeQ@mail.gmail.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <96ad4db8-024a-2c38-8a4a-8e997bd8b9c8@suse.com>
Date:   Wed, 6 Feb 2019 16:36:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAOcd+r3CzY2w94Y--9Nb+Fawv_JGFLnK3AgZdYWjNOsKth_aeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.02.19 г. 16:26 ч., Alex Lyakas wrote:
> Hi Nikolay, David,
> 
> Isn't patch 5 (btrfs: Remove extra reference count bumps in
> btrfs_compare_trees) fixing a memory leak, and hence should be tagged
> as "stable"? I am specifically interested in 4.14.x.
> 
> The comment says "remove redundant calls to extent_buffer_get since
> they don't really add any value". But with the extra ref-count, the
> extent buffer will not be properly freed and will cause a memory leak,
> won't it?

No, take a look into the logic of free_extent_buffer and see there is
special handling for cloned buffers. And in fact, the series this patch
was part of exactly removed this special handling since it's rather
non-intuitive, your email being case in point.

> 
> Thanks,
> Alex.
> 
> 
> 
> On Tue, Nov 6, 2018 at 4:30 PM David Sterba <dsterba@suse.cz> wrote:
>>
>> On Wed, Aug 15, 2018 at 06:26:50PM +0300, Nikolay Borisov wrote:
>>> Here is a series which simplifies the way eb are used in EXTENT_BUFFER_UNMAPPED
>>> context. The end goal was to remove the special "if we have ref count of 2 and
>>> EXTENT_BUFFER_UNMAPPED flag then act as if this is the last ref and free the
>>> buffer" case. To enable this the first 6 patches modify call sites which
>>> needlessly bump the reference count.
>>>
>>> Patch 1 & 2 remove some btree locking when we are operating on unmapped extent
>>> buffers. Each patch's changelog explains why this is safe to do .
>>>
>>> Patch 3,4,5 and 6 remove redundant calls to extent_buffer_get since they don't
>>> really add any value. In all 3 cases having a reference count of 1 is sufficient
>>> for the eb to be freed via btrfs_release_path.
>>>
>>> Patch 7 removes the special handling of EXTENT_BUFFER_UNMAPPED flag in
>>> free_extent_buffer. Also adjust the selftest code to account for this change
>>> by calling one extra time free_extent_buffer. Also document which references
>>> are being dropped. All in all this shouldn't have any functional bearing.
>>>
>>> This was tested with multiple full xfstest runs as well as unloading the btrfs
>>> module after each one to trigger the leak check and ensure no eb's are leaked.
>>> I've also run it through btrfs' selftests multiple times with no problems.
>>>
>>> With this set applied EXTENT_BUFFER_UNMAPPED seems to be relevant only for
>>> selftest which leads me to believe it can be removed altogether. I will
>>> investigate this next but in the meantime this series should be good to go.
>>
>> Besides the 8/7 patch, the rest was in for-next for a long time so I'm
>> merging that to misc-next, targeting 4.21. I'll do one last pass
>> thhrough fstests with the full set and then upddate and push the branch
>> so there might be some delay before it appears in the public repo.
>> Thanks for the cleanup.
> 
