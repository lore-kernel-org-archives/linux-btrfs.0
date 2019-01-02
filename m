Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAAAC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 23:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A832075B
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 23:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfABXqk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 18:46:40 -0500
Received: from mout.gmx.net ([212.227.17.20]:34593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfABXqj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 18:46:39 -0500
Received: from Damenlys-MBP.lan ([180.111.171.105]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M82zV-1hZqc9263F-00vhDh; Thu, 03
 Jan 2019 00:46:29 +0100
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
 <48804351-b8b3-b876-529a-807d05259664@gmx.com>
 <20190102163128.GY23615@twin.jikos.cz>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <fdc556bd-3134-f29e-b533-933bc6c7a2ed@gmx.com>
Date:   Thu, 3 Jan 2019 07:46:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190102163128.GY23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:r0WbHIXkOqyan49vsiufmAC1l9KicHAk8DqbBLViJbP9yERt8yQ
 ntLqDMt9IrCL15Ch0CqUYVodIf5f0bsqeTg8UWxM557eT4AxKrV/VuBU2QqHEuScx5gVOz1
 lERMrhv5ZiqJIJ5UZg+gKMsGPT3UaGr79oOpABm7zFTjR67vPjoUO8O4mJFP3Wvocdej4sA
 jMU2LaBD7FvvLcKN9pQUQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bVUvIWZRzt4=:egWwuR0MkFAXDPpelP6+6E
 I2RFDOpp5+u3cIgnkdIJudJ5B0gIL1+4JSsHdn51kkYQi83n/i9RQdFG2RLaICwKtOT9q1Veb
 ldvtfGsNVeu+JuS5vaRwczMRK9BbBUAcRHEJyv1fDKb21ms5hDKrJ+FV05pJ8pb5I1QzwQMhx
 f0JIpf3mVy1w+JdvezL8AXt/xggBC341qYaZtnRCX74HHC6ry8rso9JUxZ7xClztoScRuDWDM
 meGNPOyaHx9VFWkmrZzoQcFbnufEyeQXetRDN4adKKNV7t3DBPaZfBIUVGS6jdVs5EG/kV+In
 4LvC9wND81hJfeGdXudifxB434Tv78b8yMWUIqM8raMBOvQHMTDd7SCTfRqgy05nmm9M13IHz
 P/CquJrPqwZO2cWIsLyo09irr5hOvyB9KU7s3IYXK80dqPL1BrlokQhZ0L+CEd8U5W7XEupwy
 iV40R2ac1sa6ECHrQ/bpVvtp7coRZtf7Mn93MDolvYfvE7nq9wgXmV584qA5SwpSlWO5emj0o
 VLCDu7pBA9oQeDw5+cvkf5SMrxhDdNeCRS8tIdKilW5R/UUVFbgpyMXPK/CFP+frOiwHSUTy+
 OtxB+sLXs7JTTK7bXkZ4CRLTMkpEI1RL4OWZq8y0VBdRu+bpKlyxWpK5egwhkORaZczjl3z4p
 A6TVFqZwdh0KBgyeBeWDKyCsxcE8D/4OtvSQORJnpQuq+QOrL7OSMezMY4J47qx4aKjr6nhsx
 L6809Tr5v9qLexASePErdn15jz6MfKVL/AkkImLKwZ1tS6TZimPNiKwvgInPMlUSwhseTa9wm
 qnmYnI1bs4nXMwn0dMeglzZemDMsNmRBK1pXkM4ojrVM5kLogh0EgTW04nLIGUxr+jlFVVHUb
 kmNsn/QE7rwgXMj6//F1kX0Vi9uWhszxYVU1sVQHp61NKCX3S3bHvGyc7ATPx8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/3 12:31 AM, David Sterba wrote:
> On Thu, Dec 27, 2018 at 07:28:40PM +0800, Su Yue wrote:
>>> +}
>>> +
>>> +int create_uuid_tree(struct btrfs_trans_handle *trans)
>>> +{
>>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>>> +	struct btrfs_root *uuid_root = fs_info->uuid_root;
>>> +	struct btrfs_key key;
>>> +	int ret;
>>> +
>>> +	if (!uuid_root) {
>>> +		ret = create_empty_tree(trans, BTRFS_UUID_TREE_OBJECTID);
>>> +		if (ret < 0) {
>>> +			errno = -ret;
>>> +			error("failed to create uuid root: %m");
>>
>> In personal taste, I don't like such assignment.
>> Let the community say.
> 
> Check eg. 251d32ea5cd1cf74cb52, replaces strerror(errno) with %m and
> requires no change. As we're using strerror(-ret) in many places, it's a
> followup that needs the extra errno assignment. This is IMO a small cost
> on the source code size and the gain in space savings might be
> noticeable for embedded devices, but we need to do all the conversions.
> 

Got it, Thanks.
