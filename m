Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:60366 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761934Ab3ECNGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 09:06:19 -0400
Message-ID: <5183B652.8020300@sgi.com>
Date: Fri, 3 May 2013 08:06:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <esandeen@redhat.com>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: btrfs/276 - stop all fsstress before exiting
References: <517A10B1.7040107@redhat.com> <517A3C49.9090703@jan-o-sch.net> <7DC41D7F-396D-4769-B573-816E80372456@redhat.com>
In-Reply-To: <7DC41D7F-396D-4769-B573-816E80372456@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2013 08:10 AM, Eric Sandeen wrote:
> On Apr 26, 2013, at 3:35 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>
>> On Fri, April 26, 2013 at 07:29 (+0200), Eric Sandeen wrote:
>>> Tests after 276 were failing because the background fsstress
>>> hadn't quit prior to exit, devices couldn't be unmounted, etc.
>>
>> I don't see how that would happen. Any further insight?
>>
> Yes, sorry for not including it.  The parent process was killed, but the fsstress processes just got reparented to init.
>
> I tried for a while to use pkill to knock them of first but this seems simpler, actually.
>
> Eric
>

Jan, with Eric's explanation, may I put your Reviewed-by: on this patch?

