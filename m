From: Harshavardhana <harsha@gluster.com>
Subject: Re: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes
 and snapshots
Date: Fri, 09 Apr 2010 14:13:07 -0700
Message-ID: <4BBF9863.50504@gluster.com>
References: <1270766820-7345-1-git-send-email-harsha@gluster.com> <201004091958.36715.kreijack@libero.it> <4BBF745A.9090602@gluster.com> <201004092054.48946.kreijack@libero.it> <4BBF970E.7000903@gluster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBF970E.7000903@gluster.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2010 02:07 PM, Harshavardhana wrote:
> EBUSY is again meant for different reason where in a super block is 
> being locked or accessed by an Application which would mean unref on 
> that block would cause Application to go nuts. In such cases EBUSY is 
> returned. 
Ok i think ENOTSUPP could be another alternative? . This should be ok i 
guess?

Regards

-- 
Harshavardhana
http://www.gluster.com

