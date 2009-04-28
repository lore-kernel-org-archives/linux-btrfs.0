From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 19:29:19 +0200
Message-ID: <49F73CEF.4030105@gmail.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F728F6.6030307@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski wrote:
> Thomas Glanzmann schrieb:
>
>> 300 Gbyte of used storage of several productive VMs with the following
>> Operatings systems running:
>> \begin{itemize}
>>         \item Red Hat Linux 32 and 64 Bit (Release 3, 4 and 5)
>>         \item SuSE Linux 32 and 64 Bit (SLES 9 and 10)
>>         \item Windows 2003 Std. Edition 32 Bit
>>         \item Windows 2003 Enterprise Edition 64 Bit
>> \end{itemize}
>> \begin{tabular}{r|r|r|l}
>> blocksize & Deduplicated Data \\
>> \hline
>> 128k      &  29.9 G \\
>>  64k      &  41.3 G \\
>>  32k      &  59.2 G \\
>>  16k      &  82   G \\
>>   8k      & 112   G \\
>> \
>>
>> Bottom line with 8 K blocksize you can get more than 33% of deduped data
>> running a productive set of VMs.
>
> Did you just compare checksums, 

I wouldn't rely on crc32: it is not a strong hash,
Such deduplication can lead to various problems,
including security ones.

> or did you also compare the data "bit after bit" if the checksums 
> matched?

