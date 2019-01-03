Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123B7C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE9E2070C
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="Yv7xi+UW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfACHnZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:43:25 -0500
Received: from mail.virtall.com ([46.4.129.203]:56712 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfACHnZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 02:43:25 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 6A79A376556;
        Thu,  3 Jan 2019 07:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1546501402;
        bh=qw+9ntHJ3IdQX4P5Zj1bSKJhuzNB1897PvOKkQO97Xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Yv7xi+UWdAqLrHuAeO2CFY8H4tmMQiG7qAmvNQ3wgvvDDabFJ/tKo42tp7W4yrjNp
         swhZZyc+fxZS4ldmh2Z47fuxfDPakuu4llRjmmdAA24larNUHc1S+h83dwl5mD+rdr
         GlfUN1aeSL8YsNdJ1NE5sMdANSzREethKDX8JCAHzML555FkL1a+MIB1dVQh+w0//8
         VEyu+c2uJgm825clVFoACUmiB4kL58HSHW8Kqn3aV68wQJNguzk4NGF8PY8t1Pqey+
         8Dciha74csQYpbKT93bXf83bEg2UYhD2L7+uxQ8+YwDOKSibSrK8G/UmC9OUl0psbM
         9KSIRBhg7RMtw==
X-Fuglu-Suspect: ce8e14749f4943cbb18f876c2aade6d0
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Thu,  3 Jan 2019 07:43:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Jan 2019 16:43:20 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        b11g <b11g@protonmail.com>,
        Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
In-Reply-To: <20190103072740.GA64625@glet>
References: <155a0e09f60a0605802c459a6e119b36@virtall.com>
 <20190103072740.GA64625@glet>
Message-ID: <b5df9ec049da6ecd9a4b3617d39d795f@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-03 16:27, Andrea Gelmini wrote:
> On Thu, Jan 03, 2019 at 11:52:05AM +0900, Tomasz Chmielewski wrote:
>> Did you use 4.19.x kernels earlier than 4.19.8?
>> 
>> They had a bug which would corrupt filesystems (mostly ext4 users 
>> would be
>> reporting it, but I saw it with other filesystems, like xfs and btrfs, 
>> too):
> 
> Well, just for the record, it triggers when you have
> scsi devices using elevator=none over blkmq.
> 
> And it's not a default/usual configuration.

Still - it is a default configuration for some distributions. I.e. 
Ubuntu "ppa" kernels[1] have this enabled by default (at least 4.19.x 
and 4.20.x).


[1] https://kernel.ubuntu.com/~kernel-ppa/mainline/


Tomasz Chmielewski
https://lxadm.com
