Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65051 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2E2Ldu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 07:33:50 -0400
Received: by yhmm54 with SMTP id m54so2138397yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 04:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120529111833.GU24394@twin.jikos.cz>
References: <20120528183700.GA9588@untroubled.org>
	<4FC41AEA.2040905@huawei.com>
	<20120529111833.GU24394@twin.jikos.cz>
Date: Tue, 29 May 2012 05:33:49 -0600
Message-ID: <CAE5mzvjvjLDfk8AswgZr5sxZjg8cBD+wNk937-+x=YOjU20+JQ@mail.gmail.com>
Subject: Re: Make existing snapshots read-only?
From: cwillu <cwillu@cwillu.com>
To: dave@jikos.cz, Li Zefan <lizefan@huawei.com>, bruce@untroubled.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2012 at 5:18 AM, David Sterba <dave@jikos.cz> wrote:
> On Tue, May 29, 2012 at 08:40:10AM +0800, Li Zefan wrote:
>> > Is there any way to mark existing snapshots as read-only? Making new
>> > ones read-only is easy enough, but what about existing ones?
>>
>> We have code in the kernel side, so what we need to do is to update btrfs-progs,
>> which is trivial.
>
> Well, I don't like that it's even possible to turn a RO snapshot to a RW
> one. What was the rationale behind this back then? Besides, I think that
> it could break assumptions in the backref code.
>
> If it's only a one-way operation from a regular subvol -> RO subvol,
> this sounds reasonable to me. If the opposite direction is allowed, then
> I'd not call it 'read-only' but "unwritable on-request".

Is anyone actually expecting readonly-snapshots to be a worm
implementation?  And are they sane to expect it?

So long as the permissions required to change it are sane (admin
rights to change an arbitrary snapshot, possibly something like
write-permission on the mountpoint to change otherwise), I don't see
the gain.  It's not like root can't modify the disk directly, so
withholding an easy way to flip the readonly bit just strikes me as a
nuisance feature.
