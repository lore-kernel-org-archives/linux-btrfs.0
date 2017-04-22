Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:46122 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426910AbdDVUWm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 16:22:42 -0400
Subject: Re: Experiences with metadata balance/convert
To: Chris Murphy <lists@colorremedies.com>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
 <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
 <CAJCQCtThSgrUyAWfKb8V5FEfZBGvDxL6L6-CggON1CsJx9JFjw@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <65754bea-6634-28f9-6bc1-1f276f2fed95@mendix.com>
Date: Sat, 22 Apr 2017 22:22:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtThSgrUyAWfKb8V5FEfZBGvDxL6L6-CggON1CsJx9JFjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/22/2017 06:55 PM, Chris Murphy wrote:
> On Sat, Apr 22, 2017 at 10:45 AM, Chris Murph
>> The proper way to do this in Btrfs terms would be to COW all of the
>> changed chunk tree nodes elsewhere, all the unneeded items are
>> removed. New CRCs. And then once that succeeds and is committed to
>> stable media, new supers written to point to the new chunk and dev
>> trees which in turn now only point to one of the already written
>> copies of metadata chunks, without writing out new chunks.
> 
> Also probably needs free space cache or tree updated. But the main
> point is that nothing is overwritten in Btrfs. It'd always be COW so
> it's fail safe.

Free space tree only deals with the virtual address space, so it won't
see any difference.

-- 
Hans van Kranenburg
