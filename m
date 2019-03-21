Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07FDC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 18:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81D9B218FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 18:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dirtcellar.net header.i=@dirtcellar.net header.b="I6SDCFRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfCUS0n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 14:26:43 -0400
Received: from smtp.domeneshop.no ([194.63.252.55]:55764 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfCUS0n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 14:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dirtcellar.net; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Reply-To; bh=Du4RaSYBPvDHQhmKQMKoDbLeVPQTcR2BnimCesVIOpQ=;
        b=I6SDCFRfcyTktGaPNcIWuMyTcMSo80MIZtJtcPfzigNx5jvjKmQqUjT9JagO3HdkUNX13Z3PmLQyS2IHROnZqmojYNqeEGK6eB4TU9Jsgw250abJVdchOFu3j5H3LNUHvVMJGQxIslO2SrchDstI9B8s5wa9//5iSgtqPMYZk5/3jcG0T16lI08waVOAizjcqypo+3ejaRqpyVpID5VsChBv0TfwS8gspQ1PpeVq3ZTUWKGw6XmzWli/gQ5TDTDsLAJJSohrvosmYQRasuv3nE3Zb7evu2c7nwMG73Ze49ifhb1vGrnblNe63I+OGEJxyh7e25jGVP0m0Nd9nv7+Tw==;
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:64330 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1h72Om-0004b0-SE; Thu, 21 Mar 2019 19:26:40 +0100
Reply-To: waxhead@dirtcellar.net
Subject: Re: [PATCH RFC 0/5] readmirror feature
To:     Steven Davies <btrfs-list@steev.me.uk>,
        Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
 <d7b84e2bcb9920d011e585391b70020e@steev.me.uk>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <b6e5bd3a-2582-55d8-bf2c-feb060dc8b22@dirtcellar.net>
Date:   Thu, 21 Mar 2019 19:26:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <d7b84e2bcb9920d011e585391b70020e@steev.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Steven Davies wrote:
> On 2019-03-19 10:00, Anand Jain wrote:
>> RFC patch as of now, appreciate your comments. This patch set has
>> been tested.
>>
>> ....
>>
>> This patch introduces a framework so that we can add more policies, and
>> converts the existing %pid into as a configurable parameter using the
>> property. And also provides a transient readmirror mount option, so that
>> this property can be applied for the read io during mount and for
>> readonly FS.
> 
> Is it possible to set this property at mkfs time?
> 
>>  For example:
>>    btrfs property set <mnt> readmirror pid
>>    btrfs property set <mnt> readmirror ""
>>    btrfs property set <mnt> readmirror devid<n>
>>
>>    mount -o readmirror=pid <mnt>
>>    mount -o readmirror=devid<n> <mnt>
> 
> This is an edge case but should we be allowed to set more than one 
> device as a read mirror in a 3+ device array? In theory there could be 
> two fast disks and one slow disk where all stripes are guaranteed to be 
> on at least one fast disk.
> 
> I'll test these patches out when I have some spare time over the next 
> few weeks. Do you have a tree I can pull / what are the patches based on?
> 
> Way beyond this patch series, considering a 3+ device raid1 array with 
> mixed fast and slow disks perhaps there could also be a write preference 
> for disks to fill up the fast disks first.
> 
> Steven Davies

This is more of less a feature request , but it feels right to mention 
this here...

If I remember correctly BTRFS does not currently scale to more than 32 
devices right now (due to some striping related stuff), but if BTRFS can 
have many more devices, and even now at >16 devices would it not make 
sense to be able to "tag" devices or make "device groups".

For example - when (if) subvolumes can have different "RAID" profiles it 
would perhaps make sense to ensure that certain subvolumes would prefer 
to use storage from a certain group of devices. In a mixed setup where 
you have both SSD's, HDD's and those new M2 things (or whatever) it 
could be nice to make a subvolume for /usr or /var and ask BTRFS to 
prefer to store that on a SSD's while a subvolume for /home could be 
preferred to be stored on HDD's.

Having device groups could also allow to define certain storage devices 
for "hot data" so that data that is read often could auto-migrate to the 
faster storage devices.. As I understand BTRFS it is "just" a matter of 
setting a flag pr. chunk so it would prefer to be allocated on device of 
type/group xyz...

In a N-way mirror setup you could would read mostly from SSD's while 
using HDD's for storing the mirror copy.

if I may suggest ... I think something along the lines of...

'btrfs device setgroup DEVID GROUPNAME'
'btrfs property set GROUPNAME readweight=100, writeweight=50'
'btrfs property set GROUPNAME readmirror=whatever_policy'
and
'btrfs subvolume setgroup GROUPNAME'

would to just fine...

Again , just a suggestion from a regular BTRFS user. Nothing more , but 
please consider something like this. The current readmirror idea sounds 
a tad limited as it does not account for subvolumes.
