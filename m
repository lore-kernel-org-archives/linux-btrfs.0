Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36147 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbdBJOVb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 09:21:31 -0500
Received: by mail-vk0-f43.google.com with SMTP id t8so26330344vke.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 06:21:28 -0800 (PST)
MIME-Version: 1.0
From: Peter Zaitsev <pz@percona.com>
Date: Fri, 10 Feb 2017 09:21:27 -0500
Message-ID: <CA+RUij0XsPsnCMTj4esnpJpmP9D+HCD6uD+r-pUH=eYPwuowrA@mail.gmail.com>
Subject: Help understanding autodefrag details
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As I have been reading btrfs whitepaper  it speaks about autodefrag in very
generic terms - once random write in the file is detected it is put in the
queue to be defragmented.   Yet I could not find any specifics about this
process described anywhere.

My use case is databases and as such large files (100GB+)    so my
questions are

- is my understanding what defrag queue is based on files not parts of
files which got fragmented correct ?

- Is single random write is enough to schedule file for defrag or is there
some more elaborate math to consider file fragmented and needing
optimization  ?

- Is this queue FIFO or is it priority queue where files in more need of
fragmentation jump in front (or is there some other mechanics ?

- Will file to be attempted to be defragmented completely or does defrag
focuses on the most fragmented areas of the file first ?

- Is there any way to view this defrag queue ?

- How are resources allocated to background autodefrag vs resources serving
foreground user load are controlled

- What are space requirements for defrag ? is it required for the space to
be available for complete file copy or is it not required ?

- Can defrag handle file which is being constantly written to or is it
based on the concept what file should be idle for some time and when it is
going to be defragmented

Let me know if you have any information on these

-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
