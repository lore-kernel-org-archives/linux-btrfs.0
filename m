Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:32779 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S376935AbdD2TSn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 15:18:43 -0400
Received: by mail-yb0-f179.google.com with SMTP id 11so21851185yby.0
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 12:18:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0E7C728D-E9DD-4E04-81E3-C4F47FCA2DC9@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com>
 <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com> <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
 <0E7C728D-E9DD-4E04-81E3-C4F47FCA2DC9@redhat.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 29 Apr 2017 13:18:41 -0600
Message-ID: <CAJCQCtRJToL2v5KBrLmY89jR8bDfsRRtnCGbjPrtwT4+MOovRg@mail.gmail.com>
Subject: Re: File system corruption, btrfsck abort
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 29, 2017 at 2:46 AM, Christophe de Dinechin
<dinechin@redhat.com> wrote:

> Are there btrfs commands I could run on a read-only filesystem that would give me this information?

qemu-img info <file> will give you the status of lazy refcounts.
lsattr will show a capital C in the 3rd to last position if it's nocow
filefrag -v will show many extents with the "unwritten" flag if the
file is fallocated.

$ lsattr
------------------- ./Desktop
------------------- ./Downloads
------------------- ./Templates
------------------- ./Public
------------------- ./Documents
------------------- ./Music
------------------- ./Pictures
------------------- ./Videos
--------c---------- ./tmp                      ##enable compression
------------------- ./Applications
----------------C-- ./hello.qcow2           ##this is nocow



-- 
Chris Murphy
