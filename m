Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:44374 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbeBKJbp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Feb 2018 04:31:45 -0500
Received: by mail-lf0-f42.google.com with SMTP id c188so801973lfc.11
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Feb 2018 01:31:45 -0800 (PST)
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "Ellis H. Wilson III" <ellisw@panasas.com>,
        linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <437ef3be-58ef-9195-0422-113b5fd17bff@gmail.com>
Date: Sun, 11 Feb 2018 12:31:42 +0300
MIME-Version: 1.0
In-Reply-To: <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

11.02.2018 04:02, Hans van Kranenburg пишет:
...
> 
>> - /dev/sda6 / btrfs
>> rw,relatime,ssd,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot
>> 0 0
> 
> Note that changes on atime cause writes to metadata, which means cowing
> metadata blocks and unsharing them from a previous snapshot, only when
> using the filesystem, not even when changing things (!).

With relatime atime is updated only once after file was changed. So your
description is not entirely accurate and things should not be that
dramatic unless files are continuously being changed.


