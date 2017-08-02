Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:38852 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbdHBLZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 07:25:47 -0400
Received: by mail-io0-f177.google.com with SMTP id g13so19031918ioj.5
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 04:25:47 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1cfc817b-2f35-9ca5-9d6c-ab2c6ec53ba9@gmail.com>
Date: Wed, 2 Aug 2017 07:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-02 04:38, Brendan Hide wrote:
> The title seems alarmist to me - and I suspect it is going to be 
> misconstrued. :-/
> 
>  From the release notes at 
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/7.4_Release_Notes/chap-Red_Hat_Enterprise_Linux-7.4_Release_Notes-Deprecated_Functionality.html 
> 
> 
> "Btrfs has been deprecated
> 
> The Btrfs file system has been in Technology Preview state since the 
> initial release of Red Hat Enterprise Linux 6. Red Hat will not be 
> moving Btrfs to a fully supported feature and it will be removed in a 
> future major release of Red Hat Enterprise Linux.
> 
> The Btrfs file system did receive numerous updates from the upstream in 
> Red Hat Enterprise Linux 7.4 and will remain available in the Red Hat 
> Enterprise Linux 7 series. However, this is the last planned update to 
> this feature.
> 
> Red Hat will continue to invest in future technologies to address the 
> use cases of our customers, specifically those related to snapshots, 
> compression, NVRAM, and ease of use. We encourage feedback through your 
> Red Hat representative on features and requirements you have for file 
> systems and storage technology."

And this is a worst-case result of the fact that most distros added 
BTRFS support long before it was ready.

I'm betting some RH customer lost a lot of data because they didn't pay 
attention to the warnings and didn't do their research and were using 
raid5/6, and thus RH is considering it not worth investing in.  That, or 
they got fed up with the grandiose plans with no realistic timeline. 
There have been a number of cases of mishandled patches (chunk-level 
degraded check anyone?), and a lot of important (from an enterprise 
usage sense) features that have been proposed but to a naive outside 
have seen little to no progress (hot-spare support, device failure 
detection and handling, higher-order replication, working erasure coding 
(raid56), etc), and from both aspects, I can understand them not wanting 
to deal with it.
