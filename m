Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:62745 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab3FKQG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 12:06:57 -0400
Received: by mail-we0-f172.google.com with SMTP id q56so6142025wes.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 09:06:56 -0700 (PDT)
References: <1370893895-24884-2-git-send-email-fdmanana@gmail.com> <1370894875-26129-1-git-send-email-fdmanana@gmail.com> <20130611150052.GA7290@twin.jikos.cz>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130611150052.GA7290@twin.jikos.cz>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <2F238C72-BCF5-4DC4-B002-26704784D93D@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH 1/5] Btrfs-progs: fix closing of devices
Date: Tue, 11 Jun 2013 17:09:43 +0100
To: "dsterba@suse.cz" <dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/06/2013, at 16:00, David Sterba <dsterba@suse.cz> wrote:

> On Mon, Jun 10, 2013 at 09:07:55PM +0100, Filipe David Borba Manana wrote:
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1267,12 +1267,12 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>>    while (!list_empty(list)) {
>>        device = list_entry(list->next, struct btrfs_device, dev_list);
>>        list_del_init(&device->dev_list);
>> -        if (device->fd) {
>> +        if (device->fd > 0) {
> 
>> -        device = kmalloc(sizeof(*device), GFP_NOFS);
>> +        device = kzalloc(sizeof(*device), GFP_NOFS);
>>        if (!device)
>>            return -ENOMEM;
>> -        device->total_ios = 0;
> 
> Can you please describe the incremental change between the two patches?
> Why do you exclude fd == 0 ?

Sorry, I messed up my git send-email foo.

I excluded 0 because the original code did it too, however it was logically
incorrect. The last patch version (v2, 3rd email) does not exclude 0 and
ensures that -1 is used everywhere as a marker for invalid fd.

(Hopefully now I figured how to use git send-email to update a patch
correctly)

Thanks


> 
> david
