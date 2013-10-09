Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:60424 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3JIX2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 19:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5g0SKT+Zu9148eME=u=g5MWJ6mayE5S1xU319Vga3YiZK7YQ@mail.gmail.com>
References: <1381360387-27535-1-git-send-email-geyslan@gmail.com>
	<CA+5g0SKT+Zu9148eME=u=g5MWJ6mayE5S1xU319Vga3YiZK7YQ@mail.gmail.com>
Date: Wed, 9 Oct 2013 20:28:48 -0300
Message-ID: <CAGG-pUQ5+mEjwVj6G=oGfnY62J+NG=ZvwoGdJUENFu4LqWNCDw@mail.gmail.com>
Subject: Re: [Kernel-BR] [PATCH] btrfs: Fix memory leakage in the tree-log.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Felipe Pena <felipensp@gmail.com>
Cc: kernel-br <kernel-br@googlegroups.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Felipe, thank you,

Sending v2.

Geyslan Gregório Bem
hackingbits.com


2013/10/9 Felipe Pena <felipensp@gmail.com>:
> Hi,
>
> On Wed, Oct 9, 2013 at 8:13 PM, Geyslan G. Bem <geyslan@gmail.com> wrote:
>> In some cases, add_inode_ref() is returning without freeing
>> the 'name' pointer.
>>
>> Added bail out to explicitly call kfree when necessary.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  fs/btrfs/tree-log.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 79f057c..37d32c3 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -1170,13 +1170,18 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>>                         if (!dir)
>>                                 dir = read_one_inode(root, parent_objectid);
>>                         if (!dir)
>> -                               return -ENOENT;
>> +                       {
>> +                               ret = -ENOENT;
>> +                               goto bail;
>> +                       }
>
> No braces required here.
>
>
>>                 } else {
>>                         ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>>                                              &ref_index);
>>                 }
>>                 if (ret)
>> -                       return ret;
>> +               {
>> +                       goto bail;
>> +               }
>>
>
> Ditto.
>
>>                 /* if we already have a perfect match, we're done */
>>                 if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
>> @@ -1214,7 +1219,6 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>>                 }
>>
>>                 ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
>> -               kfree(name);
>>                 if (log_ref_ver) {
>>                         iput(dir);
>>                         dir = NULL;
>> @@ -1227,6 +1231,9 @@ out:
>>         btrfs_release_path(path);
>>         iput(dir);
>>         iput(inode);
>> +bail:
>> +       if (name)
>> +               kfree(name);
>>         return ret;
>>  }
>>
>> --
>> 1.8.4
>>
>> --
>> Você está recebendo esta mensagem porque se inscreveu no grupo "Kernel Brasil" dos Grupos do Google.
>> Para cancelar a inscrição neste grupo e parar de receber seus e-mails, envie um e-mail para kernel-br+unsubscribe@googlegroups.com.
>> Para postar neste grupo, envie um e-mail para kernel-br@googlegroups.com.
>> Para ver esta discussão na web, acesse https://groups.google.com/d/msgid/kernel-br/1381360387-27535-1-git-send-email-geyslan%40gmail.com.
>> Para obter mais opções, acesse https://groups.google.com/groups/opt_out.
>
>
>
> --
> Regards,
> Felipe Pena
