Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:37624 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdKUM0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 07:26:02 -0500
Received: by mail-vk0-f50.google.com with SMTP id 22so7506352vkq.4
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 04:26:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511266131.1680.27.camel@gmail.com>
References: <1511266131.1680.27.camel@gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 21 Nov 2017 17:55:21 +0530
Message-ID: <CAKuJGC8g1Oa-1w=v8dUxuj6qF8MXOcJ=K7uHQaJumnW4YTRNrQ@mail.gmail.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
To: ST <smntov@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seems like issue is similar to this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=197681
Whats your kernel/brtfs-prog version? Can you upgrade them to latest
if they are quite old?
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Tue, Nov 21, 2017 at 5:38 PM, ST <smntov@gmail.com> wrote:
> Hello,
>
> I'm trying to use quotas for a simple chrooted sftp setup, limiting
> space for each user's subvolume (now for testing to 1M).
>
> I tried to hit the limit by uploading files and once it comes to the
> limit I face following problem: if I try to free space by removing a
> file via Linux sftp client (or Filezilla) - I get error:
> "Couldn't delete file: Failure"
>
> Sometimes, but not always, if I repeat it for 3-5 times it does removes
> the file at the end.
> If I login as root and try to remove the file via SSH I get the error:
> "rm: cannot remove 'example.txt': Disk quota exceeded"
>
> What is the problem? And how can I solve it?
>
> Thank you in advance!
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
