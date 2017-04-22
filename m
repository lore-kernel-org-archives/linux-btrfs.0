Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36581 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425839AbdDVQzi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 12:55:38 -0400
Received: by mail-yw0-f172.google.com with SMTP id l18so4398868ywh.3
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Apr 2017 09:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com> <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 22 Apr 2017 10:55:37 -0600
Message-ID: <CAJCQCtThSgrUyAWfKb8V5FEfZBGvDxL6L6-CggON1CsJx9JFjw@mail.gmail.com>
Subject: Re: Experiences with metadata balance/convert
To: Chris Murphy <lists@colorremedies.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 22, 2017 at 10:45 AM, Chris Murph
> The proper way to do this in Btrfs terms would be to COW all of the
> changed chunk tree nodes elsewhere, all the unneeded items are
> removed. New CRCs. And then once that succeeds and is committed to
> stable media, new supers written to point to the new chunk and dev
> trees which in turn now only point to one of the already written
> copies of metadata chunks, without writing out new chunks.

Also probably needs free space cache or tree updated. But the main
point is that nothing is overwritten in Btrfs. It'd always be COW so
it's fail safe.

-- 
Chris Murphy
