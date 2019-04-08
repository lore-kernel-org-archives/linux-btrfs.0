Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABCEC282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BAC220880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=demfloro.ru header.i=@demfloro.ru header.b="LyRUtAE2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfDHI3p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:29:45 -0400
Received: from mx.demfloro.ru ([185.52.0.75]:49300 "EHLO mx.demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfDHI3p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 04:29:45 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2019 04:29:43 EDT
Received: from fire.localdomain (unknown [IPv6:2001:470:28:88::100])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: demfloro)
        by mx.demfloro.ru (Postfix) with ESMTPSA id 44d3L82WybzB9nd;
        Mon,  8 Apr 2019 08:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru; s=032019;
        t=1554711712; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=feSJYuoLXf5bLOVd1J4SrYdqQJcoCAidm+f7D8y3XeY=;
        b=LyRUtAE2l6Wde81ssX3h3YuZhs93eHL277qQXSHUvDEIddVBuGXsk0/Rzix4aDMZODfqWt
        y6SHmE/VmRsX7ZSLoWf+j2EEgydzHupdbMilUVNIuUgfXeGA5oUwzKpwVZbLbcygApTqGn
        /IddxNTsNQh/qRjPmBuNaxFy8//rrwpZFnXhLB5fbQZ6OIhN1av7MOTFs0iBa3s+0fVKCL
        3c7rZgsIg4EEaVJiBLFDN5ScDcQyFOdznUczfmtPBoZaNdxCWLdM51vXiwSwilmjva46a+
        cF7V/tCtClshWHrUQCStG+GxSQ3GaV9h843rxzSvqHaC05jBtwD37k1Wgfd86w==
Date:   Mon, 8 Apr 2019 11:21:42 +0300
From:   Dmitrii Tcvetkov <demfloro@demfloro.ru>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs tree locker performance analyser v2
Message-ID: <20190408112135.11417f65@fire.localdomain>
In-Reply-To: <de699f91-11a6-6ce1-31ec-acabcaa814a8@gmx.com>
References: <de699f91-11a6-6ce1-31ec-acabcaa814a8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru;
        s=arc032019; t=1554711712;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=feSJYuoLXf5bLOVd1J4SrYdqQJcoCAidm+f7D8y3XeY=;
        b=ARGXa7svDS3zbdfi5iXz8vOCW7dqzC/w3F3ZByaF0/akJSQavJxFPDIsq3s5GLSNnaxSue
        vVoXUQ7c9FPPzii6SvyQhEI2i4jZBHEh/VcXjfXI5h7uJvBBV8Kk0y3LrxIir3ZbUXVchw
        2HVFJxF4S+fgNSA7Cel4yGJpAHYo/yRImU3M6oBUS/CmvU8DAKdjc+ZZpIJKq/K8KNM2qq
        81OJOkCSUC8/KfZtXyT//idqf7u2v9O8k7E2NVg0H2ikHyEWdQMh5Hzv0frSg7wCHfTUfN
        vm7Cv5hCNguGj57mvN2bVklrjVag1vNYWm4ZmLo1oCZkM5TAqRlqVyHZErgWfQ==
ARC-Seal: i=1; s=arc032019; d=demfloro.ru; t=1554711712; a=rsa-sha256;
        cv=none;
        b=hNACrvYhgtp/hC4nhnkCOTfD1sB+0bTL99XVANBbogOzBqCHncH9GsTzlNVFfC3LA93b0O
        1SI/VaMe4mbWWQb71VXboCuvVPn0SZAZlHopciWwMNkFzbYnUxiGCjnIgWFOkyy5D8VaCD
        zg8DDIoHNq/5sCWLHpTUK+cchzYO2YcISkuGlnD6f3oDC+i3cBfn7YFHIv9vgbmuVnuupT
        sr3sAo4c5efCyqJ6Deeld/CqUoY6ic1/n5wq4PWIPY218Uh9FKjFkfljmW+LM1Jo6K7Zcy
        6ehQmF3D8VYNWpRaxkVnXDiT29ZsW5hHPcu+Kny4du+SPCyhdwIqXqJ3myHYCA==
ARC-Authentication-Results: i=1;
        mx.demfloro.ru;
        auth=pass smtp.auth=demfloro smtp.mailfrom=demfloro@demfloro.ru
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 8 Apr 2019 16:06:39 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> Hi,
> 
> There is the second version of btrfs tree locker analyser.
> https://gist.github.com/adam900710/766767dba5381b86534c9051780ed262
> 
> The script is also attached to the end of mail.
> 
> Please note that, it needs a trace event which is not yet merged.
> 
> That patch can be find here:
> https://patchwork.kernel.org/patch/10881305/
> 
> Unlike previous version, this version is based on trace events.
> As long as we have btrfs_tree_lock() and btrfs_tree_read_lock()
> events, we can using trace events to get all the needed info.
> 
> Compared to previous in-kernel version, this one has better
> resolution. For example, we have an event whose
> start_ns = 100ns end_ns=200,000,000ns (200ms) interval=100ms.
> 
> In previous in-kernel version, we will put all that 200ms latency into
> the checkpoint 200ms.
> 
> While in this version, we will put (100ms - 100ns) into checkpoint
> 100ms, while another 100ms into checkpoint 200ms.
> 
> Some test result can be found in google doc:
> https://docs.google.com/spreadsheets/d/1B5ETQNMq2plIcWBgEJZ5ap6NnXcAu2A4gTogGltlq4E/edit?usp=sharing
> 
> 
> The script starts below:
> 
> #!/usr/bin/python2
> # @lint-avoid-python-3-compatibility-imports
> 
> from __future__ import print_function
> from bcc import BPF
> from sys import stderr
> 
> text_bpf = '''
> #include <uapi/linux/ptrace.h>
> #define FSID_SIZE   16
> 
> struct data_t {
>     u8  fsid[FSID_SIZE];
>     u64 start_ns;
>     u64 end_ns;
>     u64 owner;
> };
> 
> BPF_PERF_OUTPUT(events);
> 
> TRACEPOINT_PROBE(btrfs, btrfs_tree_read_lock)
> {
>     struct data_t data;
> 
>     bpf_probe_read(data.fsid, FSID_SIZE, args->fsid);
>     data.start_ns = args->start_ns;
>     data.end_ns = args->end_ns;
>     data.owner = args->owner;
>     events.perf_submit(args, &data ,sizeof(data));
>     return 0;
> }
> 
> TRACEPOINT_PROBE(btrfs, btrfs_tree_lock)
> {
>     struct data_t data;
> 
>     bpf_probe_read(data.fsid, FSID_SIZE, args->fsid);
>     data.start_ns = args->start_ns;
>     data.end_ns = args->end_ns;
>     data.owner = args->owner;
>     events.perf_submit(args, &data ,sizeof(data));
>     return 0;
> }
> '''
> 
> def is_fstree(owner):
>     if owner == 5 or (owner >= 256 and owner <= (2 ** 64 - 256)):
>         return True
>     return False
> 
> # TODO: Don't use such classification while have a good idea to output
> # all the needed info
> def get_owner_str(owner):
>     if is_fstree(owner):
>         return 'SUBVOL'
>     if owner == 1:
>         return 'TREE_ROOT'
>     if owner == 2:
>         return 'EXTENT_ROOT'
>     return 'OTHER_ROOTS'
> 
> 
> '''
> Sparse dict where access to hole (non-exist) key will return 0
> other than raise an exception
> '''
> class sparse_dict:
>     data_dict = {}
>     def __init__(self):
>         self.data_dict = {}
> 
>     def __getitem__(self, key):
>         if key not in self.data_dict:
>             return 0
>         return self.data_dict[key]
> 
>     def __setitem__(self, key, value):
>         self.data_dict[key] = value;
> 
>     def __contains__(self, key):
>         return (key in self.data_dict)
> 

You can use the following for the same behaviour:

from collections import defaultdict

<snip>
> # @results is a 2 dimension dict.
> # [<aligned_timetamp>][<owner_str>] to access, no need to
> # worry about non-exist key.
> results = sparse_dict()

results = defaultdict(int)
