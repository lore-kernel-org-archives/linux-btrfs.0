Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3564C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 12:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59D332087F
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 12:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u5zh27ya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfDFMLA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 08:11:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35828 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfDFMLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 08:11:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id g8so4532280pgf.2;
        Sat, 06 Apr 2019 05:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PI371pY3oITJ6VkXzelzBhLA6ZNObyVtPYN5gZwzbXo=;
        b=u5zh27yaVbt0r7R7n3RjI40REMLfmFxgvp99ulzmU8xlES5QrBQWdcko242b6f7Nlz
         njp4YvwDvGd5VMFDuchj85DA6XRDgvAfgyFatR6aCi/V/o+V1gVTPfoVnKbFRbT+2NwU
         /TttQsVWmLQSoEyq6DvEO6H+uZnqInQv8NTboj9eHXuT9Q8ykKagNcBGxjC/ZTolUNK6
         /WclIx55lmi5z8pz1oHkE8J+iNDauijfRAFKwVEsl0SmvlS3fu7xJJLtFEFNOS2QsSxa
         BjhVo/OteNywNE4yUCfwUx9pkkoCSnerlLJOQVAR9pb6UJAZpR2c84xMDFPJWb/YcRP+
         aMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PI371pY3oITJ6VkXzelzBhLA6ZNObyVtPYN5gZwzbXo=;
        b=ZBJjIG6aAa1uPu6aCLiU8WtcaEu7kppE3Jko+wlFbzn3taltDwIguYxcMdZd163HiA
         DC2ReIlRlzOzUo9e4t7Q6abQxQXeZFQpS9FguTFwp3SawMIQ3sGssCbiSZRcqUl6Es6D
         mXsgTsX47mOpWPMqYyEINk9zq0oMGKFU6gSHUWreb/T8WdKLygfaWeGs72xe50Kn2yho
         xCrzP8dVJCfduVVlc0dp5zXCBE6FDLlMhWl5ZzLilMM6b85/270wYZ9mFzphuo5DjQP2
         duEDLeFJ2OKYZcEqGQBw25QuoQJmbMz6lx2yC9fphyNFQQOHEz/d43tT6NIUuoq5NBc4
         qmfA==
X-Gm-Message-State: APjAAAWBUpNE0J8Jg3MBZDdl0+i1sYa5CwfjI4Okd4jqdxOoLHUtkRkU
        XxZ9G/QLWoBnqBNQ/3aq3dQ=
X-Google-Smtp-Source: APXvYqwlp3xXKToys2jKUKlGZkYMa1IgWy+IUVMZDwsygeCLCQS0Cls74/6U1clviDPMjnN6zBW+yw==
X-Received: by 2002:a63:1749:: with SMTP id 9mr17030872pgx.94.1554552659471;
        Sat, 06 Apr 2019 05:10:59 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id k186sm5505882pfc.137.2019.04.06.05.10.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Apr 2019 05:10:58 -0700 (PDT)
Date:   Sat, 6 Apr 2019 20:10:51 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] fstests: log-writes: Add new option to replay/find next
 write to sector
Message-ID: <20190406121051.GH2824@desktop>
References: <20190328053507.10191-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328053507.10191-1-wqu@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 01:35:07PM +0800, Qu Wenruo wrote:
> For kernel operation we have METADATA/FUA/FLUSH flags as a beacon, but
> for user space write we don't have any useful flag unless the user space
> tool call fsync() to generate a FLUSH bio.
> 
> This means for user space write, we don't really have an equivalent of
> --next-fua to find super block write.
> 
> So this patch will add a new option, --next-write <sector> to
> replay/find next write to certain sector.
> And normally the <sector> should be super block sector number.
> 
> With that, we can replay to super block write even it's user space
> triggering the write.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This lools fine to me. But I'd like Josef or Amir to take a look at it
too, I think they're more familiar with log-writes infrastructure than
me :)

Thanks,
Eryu

> ---
>  src/log-writes/replay-log.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
> index c16df40e5741..0d0ec49c8a00 100644
> --- a/src/log-writes/replay-log.c
> +++ b/src/log-writes/replay-log.c
> @@ -9,6 +9,7 @@
>  enum option_indexes {
>  	NEXT_FLUSH,
>  	NEXT_FUA,
> +	NEXT_WRITE,
>  	START_ENTRY,
>  	END_MARK,
>  	LOG,
> @@ -28,6 +29,7 @@ enum option_indexes {
>  static struct option long_options[] = {
>  	{"next-flush", no_argument, NULL, 0},
>  	{"next-fua", no_argument, NULL, 0},
> +	{"next-write", required_argument, NULL, 0},
>  	{"start-entry", required_argument, NULL, 0},
>  	{"end-mark", required_argument, NULL, 0},
>  	{"log", required_argument, NULL, 0},
> @@ -53,6 +55,8 @@ static void usage(void)
>  	fprintf(stderr, "\t--limit <number> - number of entries to replay\n");
>  	fprintf(stderr, "\t--next-flush - replay to/find the next flush\n");
>  	fprintf(stderr, "\t--next-fua - replay to/find the next fua\n");
> +	fprintf(stderr, "\t--next-write <sector> - replay to/find the next "
> +			"write to <sector>\n");
>  	fprintf(stderr, "\t--start-entry <entry> - start at the given "
>  		"entry #\n");
>  	fprintf(stderr, "\t--start-mark <mark> - mark to start from\n");
> @@ -139,6 +143,7 @@ int main(int argc, char **argv)
>  	char *logfile = NULL, *replayfile = NULL, *fsck_command = NULL;
>  	struct log_write_entry *entry;
>  	u64 stop_flags = 0;
> +	u64 stop_sector = 0;
>  	u64 start_entry = 0;
>  	u64 start_sector = 0;
>  	u64 end_sector = -1ULL;
> @@ -173,6 +178,14 @@ int main(int argc, char **argv)
>  		case NEXT_FUA:
>  			stop_flags |= LOG_FUA_FLAG;
>  			break;
> +		case NEXT_WRITE:
> +			stop_sector = strtoull(optarg, &tmp, 0);
> +			if (tmp && *tmp != '\0') {
> +				fprintf(stderr, "Invalid sector number\n");
> +				exit(1);
> +			}
> +			tmp = NULL;
> +			break;
>  		case START_ENTRY:
>  			start_entry = strtoull(optarg, &tmp, 0);
>  			if (tmp && *tmp != '\0') {
> @@ -324,7 +337,8 @@ int main(int argc, char **argv)
>  		while ((ret = log_seek_next_entry(log, entry, 1)) == 0) {
>  			num_entries++;
>  			if ((run_limit && num_entries == run_limit) ||
> -			    should_stop(entry, stop_flags, end_mark)) {
> +			    should_stop(entry, stop_flags, end_mark) ||
> +			    (stop_sector && entry->sector == stop_sector)) {
>  				printf("%llu@%llu\n",
>  				       (unsigned long long)log->cur_entry - 1,
>  				       log->cur_pos / log->sectorsize);
> -- 
> 2.21.0
> 
