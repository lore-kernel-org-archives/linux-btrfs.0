From: Alan Chandler <alan@chandlerfamily.org.uk>
Subject: Re: Various Questions
Date: Sun, 09 Jan 2011 13:58:55 +0000
Message-ID: <4D29BF1F.5070705@chandlerfamily.org.uk>
References: <201101070915.20468.CACook@quantum-sci.com>	<201101080525.19792.CACook@quantum-sci.com>	<AANLkTi=HPx1-e09kPg0c6_UQpTCOfPe6-Q4SOUxKLnE=@mail.gmail.com>	<201101090516.09255.CACook@quantum-sci.com> <AANLkTimVie3KOmAh0Ukd8ZoADaGSQHL2YoZVmtxo3cdq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimVie3KOmAh0Ukd8ZoADaGSQHL2YoZVmtxo3cdq@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



On 09/01/11 13:37, Fajar A. Nugraha wrote:
> On Sun, Jan 9, 2011 at 8:16 PM, Carl Cook<CACook@quantum-sci.com>  wrote:
>    
>> I'd rather not do the copy again unless necessary, as it took a day.
>>
>> Directories look identical, but who knows?  I'm going to try and figure out how to do a file-by-file crc check, for peace of mind.
>>      
> try "du --apparent-size -slh"
> It should rule out any differences caused by sparse files and hardlinks.
>
>    
>>
>> On Sat 08 January 2011 17:26:25 Freddie Cash wrote:
>>      
>>> On Sat, Jan 8, 2011 at 5:25 AM, Carl Cook<CACook@quantum-sci.com>  wrote:
>>>        
>>>> In addition to the questions below, if anyone has a chance could you advise on why my destination drive has more data  than the source after this command:
>>>> # rsync --hard-links --delete --inplace --archive --numeric-ids /media/disk/* /home
>>>>          
> Are you SURE you don't get the command mixed up? The last argument to
> rsync should be the destination. Your command looks like you're
> copying things to /home.
>    

What is also important is that use of * - it means all the . files at 
the top level are NOT being copied

rsync is clever enough to notice if you have the / at the end of the 
source to know whether you want the directory to be put into the 
destination or the contents of the directory.  The / at the end of the 
source means copy the contents.

This could be (I am not sure of the exact scope of --delete) the reason 
why the destination has more data than the source.  If --delete is not 
deleting /home/.* files (if there any there).

-- 
Alan Chandler
http://www.chandlerfamily.org.uk

