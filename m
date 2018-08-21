Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726679AbeHURXL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:23:11 -0400
From: Chris Mason <clm@fb.com>
To: David Howells <dhowells@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Do btrfs compression option changes need to be atomic?
Date: Tue, 21 Aug 2018 10:02:43 -0400
Message-ID: <335C762B-3ECE-404E-959D-9982C2E15B0A@fb.com>
In-Reply-To: <476.1534859190@warthog.procyon.org.uk>
References: <31114.1534417285@warthog.procyon.org.uk>
 <476.1534859190@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21 Aug 2018, at 9:46, David Howells wrote:

> Should changes to the compression options on a btrfs mount be atomic, 
> the
> problem being that they're split across three variables?
>
> Further to that, how much of an issue is it if the configuration is 
> split out
> into its own struct that is accessed from struct btrfs_fs_info using 
> RCU?
>

Hi David,

They shouldn't need to be atomic, we're making compression decisions on 
a per-extent basis and sometimes bailing on the compression if it 
doesn't make things smaller.

-chris
