From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 05 May 2011 15:35:00 -0400
Message-ID: <4DC2FBE4.9060608@redhat.com>
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <4DC2F84F.8030107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DC2F84F.8030107@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/2011 03:19 PM, Marco Stornelli wrote:
> Il 04/05/2011 19:58, Josef Bacik ha scritto:
>> + if (offset>= i_size_read(inode)) {
>> + mutex_unlock(&inode->i_mutex);
>> + return -ENXIO;
>> + }
>> + offset = i_size_read(inode);
>> + break;
>
> I can add that generic_file_llseek_unlocked means *unlocked* so you
> shouldn't unlock any mutex but only return a value. The current version,
> in case of SEEK_END uses directly i_size indeed, so maybe I'm missing
> something.

Yeah this was a copy+paste mistake, ext4 has it's own llseek that I 
modified to run my tests against and then I just copied and pasted it 
over to the generic things.  I've fixed this earlier, I'll be sending a 
refreshed set out soon.  Thanks,

Josef
