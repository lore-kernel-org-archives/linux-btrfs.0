From: "Jeff Mahoney" <jeffm@suse.com>
Subject: Re: [patch 01/65] btrfs: Add btrfs_panic()
Date: Mon, 10 Oct 2011 10:54:57 -0600
Message-ID: <4E92CF170200007E000BC770@novprvoes0310.provo.novell.com>
References: <20111004032230.458853274@suse.com>
 <20111004032300.032619517@suse.com> <20111010164244.GJ17912@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <chris.mason@oracle.com>, <linux-btrfs@vger.kernel.org>
To: <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111010164244.GJ17912@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Uppercase BTRFS follows the convention of __btrfs_std_error. It's also the same convention other linux filesystems use. I'd view the printks that are already there as ad-hoc, to be replaced by a standard fs call that will perform formatting.

-Jeff

--
Jeff Mahoney
(apologies for the top post -- from my mobile)

On Oct 10, 2011, at 12:43 PM, "David Sterba <dave@jikos.cz>" <dave@jikos.cz> wrote:

> On Mon, Oct 03, 2011 at 11:22:31PM -0400, Jeff Mahoney wrote:
>> @@ -143,6 +146,36 @@ void __btrfs_std_error(struct btrfs_fs_i
>>    btrfs_handle_error(fs_info);
>> }
>> 
>> +/*
>> + * __btrfs_panic decodes unexpected, fatal errors from the caller,
>> + * issues an alert, and either panics or BUGs, depending on mount options.
>> + */
>> +void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
>> +           unsigned int line, int errno, const char *fmt, ...)
>> +{
>> +    char nbuf[16];
>> +    char *s_id = "<unknown>";
>> +    const char *errstr;
>> +    struct va_format vaf = { .fmt = fmt };
>> +    va_list args;
>> +
>> +    if (fs_info)
>> +        s_id = fs_info->sb->s_id;
>> +
>> +    va_start(args, fmt);
>> +    vaf.va = &args;
>> +
>> +    errstr = btrfs_decode_error(fs_info, errno, nbuf);
>> +    if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
>> +        panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
>                                 ^^^^^
> "btrfs"
> Most messages use lowercase btrfs, let's keep it like that (apart from
> missing btrfs prefixes at all or 3x Btrfs)
> 
>> +            s_id, function, line, &vaf, errstr);
>> +
>> +    printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
>                          ^^^^^
> 
>> +           s_id, function, line, &vaf, errstr);
>> +    va_end(args);
>> +    /* Caller calls BUG() */
>> +}
>> +
>> static void btrfs_put_super(struct super_block *sb)
>> {
>>    struct btrfs_root *root = btrfs_sb(sb);

