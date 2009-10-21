From: John Dong <jdong@ubuntu.com>
Subject: Re: btrfsck aborts after transid verify failed?
Date: Wed, 21 Oct 2009 09:48:07 -0400
Message-ID: <4ADF1117.6020903@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hmph, apparently sending HTML-containing e-mail is more of a taboo than 
I thought!

-------- Original Message --------
Subject: 	Re: btrfsck aborts after transid verify failed?
Date: 	Wed, 21 Oct 2009 09:45:54 -0400
From: 	John Dong <jdong@ubuntu.com>
To: 	Yan, Zheng <yanzheng@21cn.com>
CC: 	linux-btrfs@vger.kernel.org



On 10/21/2009 09:44 AM, Yan, Zheng wrote:
> On Wed, Oct 21, 2009 at 9:21 PM, John Dong<jdong@ubuntu.com>  wrote:
>    
>> >  On Oct 21, 2009, at 3:47 AM, Yan, Zheng wrote:
>>      
>>> >>
>>> >>  Did you run btrfsck on mounted FS ?
>>> >>
>>> >>  Yan, Zheng
>>>        
>> >
>> >  Yes, I did. I thought it was okay to do so?
>>      
> No, btrfs doesn't support that.
>    
Whoops! My bad then!

BTW, the wiki still says

http://btrfs.wiki.kernel.org/index.php/Btrfsck:

Do a limited check of the FS extent trees. Can be run on mounted and 
unmounted FS.

