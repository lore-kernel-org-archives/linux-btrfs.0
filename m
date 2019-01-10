Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E057C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 07:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FDB320657
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 07:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfAJHDM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 02:03:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:36844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727220AbfAJHDL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 02:03:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F063FACBC;
        Thu, 10 Jan 2019 07:03:09 +0000 (UTC)
Subject: Re: [PATCH] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
To:     dsterba@suse.cz, fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181213211725.14832-1-fdmanana@kernel.org>
 <20190109182653.GN23615@twin.jikos.cz>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <8b224e15-24f1-e269-cec3-52fd7ef39f18@suse.com>
Date:   Thu, 10 Jan 2019 09:03:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190109182653.GN23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 9.01.19 г. 20:26 ч., David Sterba wrote:
> On Thu, Dec 13, 2018 at 09:17:25PM +0000, fdmanana@kernel.org wrote:
>> -	if (list_empty(&fs_devices->resized_devices))
>> -		return;
>> -
>> -	mutex_lock(&fs_devices->device_list_mutex);
>>  	mutex_lock(&fs_info->chunk_mutex);
>>  	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
>>  				 resized_list) {
>> @@ -7309,7 +7306,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
>>  		curr->commit_total_bytes = curr->disk_total_bytes;
> 
> I'm not sure about removing the device_list_mutex that's said to protect
> the commit_total_bytes (comment in struct btrfs_device).
> 
> Otherwise the logic is ok, the double lock could happen as you describe.
> 
> btrfs_update_commit_device_size is called from btrfs_commit_transaction,
> at the same time as commit_bytes_used. The latter is handled in a
> similar way in btrfs_update_commit_device_bytes_used, but does not take
> the device_list_mutex.
> 
> commit_total_bytes is checked several times (eg. in write_dev_supers) to
> see if writing the superblock copy is still within the device range.
> 
> So, without the protected change, it's theoretically possible that a
> stale value is used for the test and the superblock is either written
> though it should not, and the other way around.

But can it really, btrfs_[grow|shrink]_device happen under transaction
and their modification of the device_disk_total_bytes (the value
assigned to commit_total_bytes) always happen under chunk_mutex. Also
the updates to both values are really owned by the transaction, so even
if grow/shrink modify those value they will queue those changes in a new
transaction, hence write_dev_super will see consistent value in the
current transaction.


I have a patch from Jeff (which is part of a bigger work) that actually
unifies the resize/device size change lists into a single single and
makes the code a bit easier to grok, nevertheless the above explanation
is still correct even without this patch.


> 
> This would require a resize racing at the time of the check. Grow and
> shrink seem to take chunk_mutex while adjusting all the total/size
> values, but it's not actually easy to follow as sometimes there are
> helpers like btrfs_device_set_total_bytes used and sometimes it's direct
> access.
> 
> That the device_list_mutex can be safely dropped probably follows from
> the simple fact that btrfs_update_commit_device_bytes_used is called
> before write_dev_supers in the same context.
> 
> But this sounds too simple, given that there are locks taken and
> released and btrfs_write_and_wait_transaction called between.
> 
> Referencing this code:
> 
> 2201         btrfs_update_commit_device_size(fs_info);
> 2202         btrfs_update_commit_device_bytes_used(cur_trans);
> 2203
> 2204         clear_bit(BTRFS_FS_LOG1_ERR, &fs_info->flags);
> 2205         clear_bit(BTRFS_FS_LOG2_ERR, &fs_info->flags);
> 2206
> 2207         btrfs_trans_release_chunk_metadata(trans);
> 2208
> 2209         spin_lock(&fs_info->trans_lock);
> 2210         cur_trans->state = TRANS_STATE_UNBLOCKED;
> 2211         fs_info->running_transaction = NULL;
> 2212         spin_unlock(&fs_info->trans_lock);
> 2213         mutex_unlock(&fs_info->reloc_mutex);
> 2214
> 2215         wake_up(&fs_info->transaction_wait);
> 2216
> 2217         ret = btrfs_write_and_wait_transaction(trans);
> 2218         if (ret) {
> 2219                 btrfs_handle_fs_error(fs_info, ret,
> 2220                                       "Error while writing out transaction");
> 2221                 mutex_unlock(&fs_info->tree_log_mutex);
> 2222                 goto scrub_continue;
> 2223         }
> 2224
> 2225         ret = write_all_supers(fs_info, 0);
> 
